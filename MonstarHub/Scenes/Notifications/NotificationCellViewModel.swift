//
//  NotificationCellViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

class NotificationCellViewModel: DefaultTableViewCellViewModel {

    let notification: Domain.Notification

    let userSelected = PublishSubject<User>()

    init(with notification: Domain.Notification) {
        self.notification = notification
        super.init()
        let actionText = notification.subject?.title ?? ""
        let repoName = notification.repository?.fullname ?? ""
        title.accept([repoName, actionText].joined(separator: "\n"))
        detail.accept(notification.updatedAt?.toRelative())
        imageUrl.accept(notification.repository?.owner?.avatarUrl)
    }
}

extension NotificationCellViewModel {
    static func == (lhs: NotificationCellViewModel, rhs: NotificationCellViewModel) -> Bool {
        return lhs.notification == rhs.notification
    }
}
