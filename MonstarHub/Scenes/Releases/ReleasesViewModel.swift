//
//  ReleasesViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Domain

class ReleasesViewModel: ViewModel, InputOutType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let selection: Driver<ReleaseCellViewModel>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let items: BehaviorRelay<[ReleaseCellViewModel]>
        let releaseSelected: Driver<URL>
        let userSelected: Driver<User>
    }

    let repository: BehaviorRelay<Repository>
    let userSelected = PublishSubject<User>()
    typealias Services = AppServices
    private let services: Services

    init(repository: Repository, services: Services) {
        self.repository = BehaviorRelay(value: repository)
        self.services = services
        super.init()
    }

    func transform(input: Input) -> Output {

        let elements = BehaviorRelay<[ReleaseCellViewModel]>(value: [])

        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[ReleaseCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.headerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[ReleaseCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.request()
                .trackActivity(self.footerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(elements.value + items)
            }).disposed(by: rx.disposeBag)

        let navigationTitle = repository.map({ (repository) -> String in
            return repository.fullname ?? ""
        }).asDriver(onErrorJustReturn: "")

        let releaseSelected = input.selection.map { (cellViewModel) -> URL? in
            cellViewModel.release.htmlUrl?.url
        }.filterNil()

        let userDetails = userSelected.asDriver(onErrorJustReturn: User())

        return Output(navigationTitle: navigationTitle,
                      items: elements,
                      releaseSelected: releaseSelected,
                      userSelected: userDetails)
    }

    func request() -> Observable<[ReleaseCellViewModel]> {
        let fullname = repository.value.fullname ?? ""
        return services.gitHubUseCase
            .releases(fullname: fullname, page: page)
            .trackActivity(loading)
            .trackError(error)
            .map { $0.map({ (release) -> ReleaseCellViewModel in
                let viewModel = ReleaseCellViewModel(with: release)
                viewModel.userSelected.bind(to: self.userSelected).disposed(by: self.rx.disposeBag)
                return viewModel
            })}
    }
}
