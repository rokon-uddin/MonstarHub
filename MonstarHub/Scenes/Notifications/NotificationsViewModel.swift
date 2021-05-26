//
//  NotificationsViewModel.swift
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

enum NotificationsMode {
    case mine
    case repository(repository: Repository)
}

class NotificationsViewModel: ViewModel, InputOutType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let segmentSelection: Observable<NotificationSegments>
        let markAsReadSelection: Observable<Void>
        let selection: Driver<NotificationCellViewModel>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let imageUrl: Driver<URL?>
        let items: BehaviorRelay<[NotificationCellViewModel]>
        let userSelected: Driver<User>
        let repositorySelected: Driver<Repository>
        let markAsReadSelected: Driver<Void>
    }

    let mode: BehaviorRelay<NotificationsMode>
    let all = BehaviorRelay(value: false)
    let participating = BehaviorRelay(value: false)
    let userSelected = PublishSubject<User>()
    typealias Services = AppServices
    let services: Services

    init(mode: NotificationsMode, services: Services) {
        self.mode = BehaviorRelay(value: mode)
        self.services = services
        super.init()
    }

    func transform(input: Input) -> Output {
        input.segmentSelection.map { $0 == .all }.bind(to: all).disposed(by: rx.disposeBag)
        input.segmentSelection.map { $0 == .participating }.bind(to: participating).disposed(by: rx.disposeBag)

        let elements = BehaviorRelay<[NotificationCellViewModel]>(value: [])

        let markAsRead = input.markAsReadSelection.flatMapLatest { () -> Observable<Void> in
            return self.markAsReadRequest()
        }.asDriver(onErrorJustReturn: ())

        let refresh = Observable.of(input.headerRefresh, input.segmentSelection.mapToVoid(), markAsRead.asObservable()).merge()
        refresh.flatMapLatest({ [weak self] () -> Observable<[NotificationCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.headerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[NotificationCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.request()
                .trackActivity(self.footerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(elements.value + items)
            }).disposed(by: rx.disposeBag)

        let userDetails = userSelected.asDriver(onErrorJustReturn: User())

        let repositoryDetails = input.selection.map { $0.notification.repository }.filterNil()

        let navigationTitle = mode.map({ (_) -> String in
            return R.string.localizable.notificationsNavigationTitle.key.localized()
        }).asDriver(onErrorJustReturn: "")

        let imageUrl = mode.map({ (mode) -> URL? in
            switch mode {
            case .mine: return nil
            case .repository(let repository): return repository.owner?.avatarUrl?.url
            }
        }).asDriver(onErrorJustReturn: nil)

        return Output(navigationTitle: navigationTitle,
                      imageUrl: imageUrl,
                      items: elements,
                      userSelected: userDetails,
                      repositorySelected: repositoryDetails,
                      markAsReadSelected: markAsRead)
    }

    func request() -> Observable<[NotificationCellViewModel]> {
        var request: Single<[Domain.Notification]>
        switch mode.value {
        case .mine:
            request = services.gitHubUseCase
                .notifications(all: all.value, participating: participating.value, page: page)
        case .repository(let repository):
            request = services.gitHubUseCase
                .repositoryNotifications(fullname: repository.fullname ?? "", all: all.value, participating: participating.value, page: page)
        }
        return request
            .trackActivity(loading)
            .trackError(error)
            .map { $0.map({ (event) -> NotificationCellViewModel in
                let viewModel = NotificationCellViewModel(with: event)
                viewModel.userSelected.bind(to: self.userSelected).disposed(by: self.rx.disposeBag)
                return viewModel
            })}
    }

    func markAsReadRequest() -> Observable<Void> {
        var request: Single<Void>
        switch mode.value {
        case .mine:
            request = services.gitHubUseCase
                .markAsReadNotifications()
        case .repository(let repository):
            request = services.gitHubUseCase
                .markAsReadRepositoryNotifications(fullname: repository.fullname ?? "")
        }
        return request
            .trackActivity(loading)
            .trackError(error)
    }
}
