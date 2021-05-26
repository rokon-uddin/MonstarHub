//
//  MainFlow.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import RxFlow

final class MainFlow: Flow {

    // MARK: - Assets
    private let services: AppServices

    var root: Presentable {
        rootViewController
    }

    private lazy var rootViewController: HomeTabBarController = {
        return HomeTabBarController(viewModel: HomeTabBarViewModel(authorized: false))
    }()

    // MARK: - Initialization

    init(services: AppServices) {
        self.services = services
    }

    deinit {
        printDebugMessage(
            domain: String(describing: self),
            message: "was deinitialized",
            type: .info
        )
    }

    // MARK: - Functions

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainStep else {
            return .none
        }
        switch step {
        case .main:
            return summonRootTabBar()
        }
    }
}

private extension MainFlow {

    func summonRootTabBar() -> FlowContributors {
        let searchFlow = SearchFlow(services: services)
        let loginFlow = LoginFlow(services: services)
        let settingsFlow = SettingsFlow(services: services)
        let flows: [Flow] = [searchFlow, loginFlow, settingsFlow]

        Flows.use(flows, when: .ready) { [rootViewController] viewControllers in
            viewControllers[0].tabBarItem = HomeTabBarItem.search.getTabBarItem()
            viewControllers[1].tabBarItem = HomeTabBarItem.login.getTabBarItem()
            viewControllers[2].tabBarItem = HomeTabBarItem.settings.getTabBarItem()
            rootViewController.setViewControllers(viewControllers, animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: searchFlow, withNextStepper: SearchStepper()),
            .contribute(withNextPresentable: loginFlow, withNextStepper: LoginStepper()),
            .contribute(withNextPresentable: settingsFlow, withNextStepper: SettingsStepper())
        ])
    }
}
