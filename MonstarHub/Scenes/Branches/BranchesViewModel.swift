//
//  BranchesViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Domain

class BranchesViewModel: ViewModel, InputOutType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let selection: Driver<BranchCellViewModel>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let items: BehaviorRelay<[BranchCellViewModel]>
    }

    let repository: BehaviorRelay<Repository>
    let branchSelected = PublishSubject<Branch>()

    typealias Services = AppServices
    var services: Services!

    init(repository: Repository, services: Services) {
        self.repository = BehaviorRelay(value: repository)
        self.services = services
    }

    func transform(input: Input) -> Output {

        let elements = BehaviorRelay<[BranchCellViewModel]>(value: [])

        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[BranchCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.headerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[BranchCellViewModel]> in
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

        input.selection.asObservable().map { $0.branch }.bind(to: branchSelected).disposed(by: rx.disposeBag)

        return Output(navigationTitle: navigationTitle,
                      items: elements)
    }

    func request() -> Observable<[BranchCellViewModel]> {
        let fullname = repository.value.fullname ?? ""
        return services.gitHubUseCase
            .branches(fullname: fullname, page: page)
            .trackActivity(loading)
            .trackError(error)
            .map { $0.map({ (branch) -> BranchCellViewModel in
                let viewModel = BranchCellViewModel(with: branch)
                return viewModel
            })}
    }
}
