//
//  UsersViewModel.swift
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

enum UsersMode {
    case followers(user: User)
    case following(user: User)

    case watchers(repository: Repository)
    case stars(repository: Repository)
    case contributors(repository: Repository)
}

class UsersViewModel: ViewModel, InputOutType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let keywordTrigger: Driver<String>
        let textDidBeginEditing: Driver<Void>
        let selection: Driver<UserCellViewModel>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let items: BehaviorRelay<[UserCellViewModel]>
        let imageUrl: Driver<URL?>
        let textDidBeginEditing: Driver<Void>
        let dismissKeyboard: Driver<Void>
        let userSelected: Driver<User>
    }

    let mode: BehaviorRelay<UsersMode>
    typealias Services = AppServices
    private let services: Services

    init(mode: UsersMode, services: Services) {
        self.mode = BehaviorRelay(value: mode)
        self.services = services
        super.init()
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[UserCellViewModel]>(value: [])
        let dismissKeyboard = input.selection.mapToVoid()

        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[UserCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.headerLoading)
        }).subscribe(onNext: { (items) in
            elements.accept(items)
        }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[UserCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.request()
                .trackActivity(self.footerLoading)
        }).subscribe(onNext: { (items) in
            elements.accept(elements.value + items)
        }).disposed(by: rx.disposeBag)

        let textDidBeginEditing = input.textDidBeginEditing

        let userDetails = input.selection.map { $0.user }

        let navigationTitle = mode.map({ (mode) -> String in
            switch mode {
            case .followers: return R.string.localizable.usersFollowersNavigationTitle.key.localized()
            case .following: return R.string.localizable.usersFollowingNavigationTitle.key.localized()
            case .watchers: return R.string.localizable.usersWatchersNavigationTitle.key.localized()
            case .stars: return R.string.localizable.usersStargazersNavigationTitle.key.localized()
            case .contributors: return R.string.localizable.usersContributorsNavigationTitle.key.localized()
            }
        }).asDriver(onErrorJustReturn: "")

        let imageUrl = mode.map({ (mode) -> URL? in
            switch mode {
            case .followers(let user),
                 .following(let user):
                return user.avatarUrl?.url
            case .watchers(let repository),
                 .stars(let repository),
                 .contributors(let repository):
                return repository.owner?.avatarUrl?.url
            }
        }).asDriver(onErrorJustReturn: nil)

        return Output(navigationTitle: navigationTitle,
                      items: elements,
                      imageUrl: imageUrl,
                      textDidBeginEditing: textDidBeginEditing,
                      dismissKeyboard: dismissKeyboard,
                      userSelected: userDetails)
    }

    func request() -> Observable<[UserCellViewModel]> {
        var request: Single<[User]>
        switch self.mode.value {
        case .followers(let user):
            request = services.gitHubUseCase
                .userFollowers(username: user.login ?? "", page: page)
        case .following(let user):
            request = services.gitHubUseCase
                .userFollowing(username: user.login ?? "", page: page)
        case .watchers(let repository):
            request = services.gitHubUseCase
                .watchers(fullname: repository.fullname ?? "", page: page)
        case .stars(let repository):
            request = services.gitHubUseCase
                .stargazers(fullname: repository.fullname ?? "", page: page)
        case .contributors(let repository):
            request = services.gitHubUseCase
                .contributors(fullname: repository.fullname ?? "", page: page)
        }
        return request
            .trackActivity(loading)
            .trackError(error)
            .map { $0.map { UserCellViewModel(with: $0) } }
    }
}
