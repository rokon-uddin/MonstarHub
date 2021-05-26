//
//  WelcomeFlow.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxFlow
import RxCocoa
import RxSwift
import Domain

final class WelcomeFlow: Flow {

    // MARK: - Assets

    var root: Presentable {
        rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let nc = NavigationController()
        nc.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nc.navigationBar.shadowImage = UIImage()
        nc.navigationBar.isTranslucent = true
            nc.view.backgroundColor = .clear
        return nc
    }()

    // MARK: - Initialization

    init() { }

    deinit {
        printDebugMessage(
            domain: String(describing: self),
            message: "was deinitialized",
            type: .info
        )
    }

    // MARK: - Functions

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? WelcomeStep else {
            return .none
        }
        switch step {
        case .login:
            return summonLoginWindow()
        case .oneTimePassword:
            return summonOTPWindow()
        case .forgotPassword:
            return summonForgotPasswordWindow()
        case .setPermissions:
            return summonSetPermissions()
        case .dismiss:
            return dismissWelcomeWindow()
        }
    }
}

private extension WelcomeFlow {

    private func summonLoginWindow() -> FlowContributors {
        return .none
    }

    private func summonOTPWindow() -> FlowContributors {
        return .none
    }

    private func summonForgotPasswordWindow() -> FlowContributors {
        return .none
    }

    private func summonSetPermissions() -> FlowContributors {
        return .none
    }

    private func dismissWelcomeWindow() -> FlowContributors {
        .end(forwardToParentFlowWithStep: WelcomeStep.dismiss)
    }
}
