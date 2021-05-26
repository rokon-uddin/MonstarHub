//
//  RepositoriesViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Domain
import RxDataSources

enum RepositoriesMode {
    case userRepositories(user: User)
    case userStarredRepositories(user: User)
    case userWatchingRepositories(user: User)

    case forks(repository: Repository)
}

class RepositoriesViewModel: ViewModel, InputOutType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let keywordTrigger: Driver<String>
        let textDidBeginEditing: Driver<Void>
        let selection: Driver<RepositoryCellViewModel>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let items: BehaviorRelay<[RepositoryCellViewModel]>
        let imageUrl: Driver<URL?>
        let textDidBeginEditing: Driver<Void>
        let dismissKeyboard: Driver<Void>
        let repositorySelected: Driver<Repository>
    }

    let mode: BehaviorRelay<RepositoriesMode>
    typealias Services = AppServices
    var services: Services!

    init(mode: RepositoriesMode, services: Services) {
        self.mode = BehaviorRelay(value: mode)
        self.services = services
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[RepositoryCellViewModel]>(value: [])
        let dismissKeyboard = input.selection.mapToVoid()

        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[RepositoryCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.headerLoading)
        }).subscribe(onNext: { (items) in
            elements.accept(items)
        }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[RepositoryCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.request()
                .trackActivity(self.footerLoading)
        }).subscribe(onNext: { (items) in
            elements.accept(elements.value + items)
        }).disposed(by: rx.disposeBag)

        let textDidBeginEditing = input.textDidBeginEditing

        let repositoryDetails = input.selection.map { $0.repository }

        let navigationTitle = mode.map({ (mode) -> String in
            switch mode {
            case .userRepositories: return R.string.localizable.repositoriesRepositoriesNavigationTitle.key.localized()
            case .userStarredRepositories: return R.string.localizable.repositoriesStarredNavigationTitle.key.localized()
            case .userWatchingRepositories: return "Watching"
            case .forks: return R.string.localizable.repositoriesForksNavigationTitle.key.localized()
            }
        }).asDriver(onErrorJustReturn: "")

        let imageUrl = mode.map({ (mode) -> URL? in
            switch mode {
            case .userRepositories(let user),
                 .userStarredRepositories(let user),
                 .userWatchingRepositories(let user):
                return user.avatarUrl?.url
            case .forks(let repository):
                return repository.owner?.avatarUrl?.url
            }
        }).asDriver(onErrorJustReturn: nil)

        return Output(navigationTitle: navigationTitle,
                      items: elements,
                      imageUrl: imageUrl,
                      textDidBeginEditing: textDidBeginEditing,
                      dismissKeyboard: dismissKeyboard,
                      repositorySelected: repositoryDetails)
    }

    func request() -> Observable<[RepositoryCellViewModel]> {
        var request: Single<[Repository]>
        switch self.mode.value {
        case .userRepositories(let user):
            request = services.gitHubUseCase.userRepositories(username: user.login ?? "", page: page)
        case .userStarredRepositories(let user):
            request = services.gitHubUseCase.userStarredRepositories(username: user.login ?? "", page: page)
        case .userWatchingRepositories(let user):
            request = services.gitHubUseCase.userWatchingRepositories(username: user.login ?? "", page: page)
        case .forks(let repository):
            request = services.gitHubUseCase.forks(fullname: repository.fullname ?? "", page: page)
        }
        return request
            .trackActivity(loading)
            .trackError(error)
            .map { $0.map { RepositoryCellViewModel(with: $0) } }
    }
}
