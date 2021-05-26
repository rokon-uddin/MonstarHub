//
//  LoginFlow.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxFlow
import RxCocoa
import RxSwift
import Domain

final class LoginFlow: Flow {

    // MARK: - Assets

    private let services: AppServices


    var root: Presentable {
        rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        return NavigationController()
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
        guard let step = transform(step: step) as? LoginStep else {
            return .none
        }
        switch step {
        case .list:
            return summonMessagesController()
        case .dismissChildFlow:
            return dismissChildFlow()
        }
    }

    private func transform(step: Step) -> Step? {
        return LoginStep.list
    }
}

private extension LoginFlow {

    func summonMessagesController() -> FlowContributors {
        let viewModel = LoginViewModel(services: services)
        let viewController = LoginViewController(viewModel: viewModel)
        rootViewController.setViewControllers([viewController], animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func dismissChildFlow() -> FlowContributors {
        rootViewController.presentedViewController?.dismiss(animated: true, completion: nil)
        return .none
    }
}
