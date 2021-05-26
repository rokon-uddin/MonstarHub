//
//  HomeTabBarViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhatsNewKit
import Domain

class HomeTabBarViewModel: ViewModel, InputOutType {

    struct Input {
        let whatsNewTrigger: Observable<Void>
    }

    struct Output {
        let tabBarItems: Driver<[HomeTabBarItem]>
        let openWhatsNew: Driver<WhatsNewBlock>
    }

    let authorized: Bool
    let whatsNewManager: WhatsNewManager

    init(authorized: Bool) {
        self.authorized = authorized
        whatsNewManager = WhatsNewManager.shared
        super.init()
    }

    func transform(input: Input) -> Output {

        let tabBarItems = Observable.just(authorized).map { (authorized) -> [HomeTabBarItem] in
            if authorized {
                return [.news, .search, .notifications, .settings]
            } else {
                return [.search, .login, .settings]
            }
        }.asDriver(onErrorJustReturn: [])

        let whatsNew = whatsNewManager.whatsNew()
        let whatsNewItems = input.whatsNewTrigger.take(1).map { _ in whatsNew }

        return Output(tabBarItems: tabBarItems,
                      openWhatsNew: whatsNewItems.asDriverOnErrorJustComplete())
    }
}
