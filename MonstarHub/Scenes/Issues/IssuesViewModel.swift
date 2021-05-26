//
//  IssuesViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import Domain

class IssuesViewModel: ViewModel, InputOutType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let segmentSelection: Observable<IssueSegments>
        let selection: Driver<IssueCellViewModel>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let imageUrl: Driver<URL?>
        let items: BehaviorRelay<[IssueCellViewModel]>
        let userSelected: Driver<User>
        let issueSelected: Driver<(issue: Issue, repository: Repository) >
    }

    let repository: BehaviorRelay<Repository>
    let segment = BehaviorRelay<IssueSegments>(value: .open)
    let userSelected = PublishSubject<User>()
    typealias Services = AppServices
    let services: Services

    init(repository: Repository, services: Services) {
        self.repository = BehaviorRelay(value: repository)
        self.services = services
        if let fullname = repository.fullname {
            analytics.log(.issues(fullname: fullname))
        }
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[IssueCellViewModel]>(value: [])

        input.segmentSelection.bind(to: segment).disposed(by: rx.disposeBag)

        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[IssueCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.headerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[IssueCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.request()
                .trackActivity(self.footerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(elements.value + items)
            }).disposed(by: rx.disposeBag)

        let userDetails = userSelected.asDriver(onErrorJustReturn: User())

        let navigationTitle = repository.map({ (_) -> String in
            return R.string.localizable.eventsNavigationTitle.key.localized()
        }).asDriver(onErrorJustReturn: "")

        let imageUrl = repository.map({ (repository) -> URL? in
            repository.owner?.avatarUrl?.url
        }).asDriver(onErrorJustReturn: nil)

        let issueSelected = input.selection.map { cell -> (issue: Issue, repository: Repository) in
            let repo = self.repository.value
            let issue = cell.issue
            return (issue, repo)
        }

        return Output(navigationTitle: navigationTitle,
                      imageUrl: imageUrl,
                      items: elements,
                      userSelected: userDetails,
                      issueSelected: issueSelected)
    }

    func request() -> Observable<[IssueCellViewModel]> {
        let fullname = repository.value.fullname ?? ""
        let state = segment.value.state.rawValue
        return services.gitHubUseCase
            .issues(fullname: fullname, state: state, page: page)
            .trackActivity(loading)
            .trackError(error)
            .map { $0.map({ (issue) -> IssueCellViewModel in
                let viewModel = IssueCellViewModel(with: issue)
                viewModel.userSelected.bind(to: self.userSelected).disposed(by: self.rx.disposeBag)
                return viewModel
            })
        }
    }
}
