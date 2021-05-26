//
//  TrendingUserCellViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

class TrendingUserCellViewModel: DefaultTableViewCellViewModel {

    let user: TrendingUser

    init(with user: TrendingUser) {
        self.user = user
        super.init()
        title.accept("\(user.username ?? "") (\(user.name ?? ""))")
        detail.accept(user.repo?.fullname)
        imageUrl.accept(user.avatar)
        badge.accept(R.image.icon_cell_badge_user()?.template)
        badgeColor.accept(UIColor.Material.green900)
    }
}

extension TrendingUserCellViewModel {
    static func == (lhs: TrendingUserCellViewModel, rhs: TrendingUserCellViewModel) -> Bool {
        return lhs.user == rhs.user
    }
}
