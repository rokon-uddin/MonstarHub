//
//  RootFlow.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxFlow
import Domain
import NetworkPlatform

class RootFlow: Flow {


    private let provider: Domain.UseCaseProvider
    // MARK: - Assets

    var root: Presentable {
        rootWindow
    }

    // MARK: - Properties

    let rootWindow: UIWindow

    // MARK: - Initialization

    init(rootWindow: UIWindow, provider: Domain.UseCaseProvider = NetworkPlatform.UseCaseProvider()) {
        self.rootWindow = rootWindow
        self.provider = provider
    }

    private var services: AppServices {
        let services = AppServices(gitHubUseCase: provider.makeGitHubUseCase(),
                                          codeTabsUseCase: provider.makeCodeTabsUseCase(),
                                          trendingGitHubUseCase: provider.makeTrendingGitHubUseCase())
        return services
    }

    // MARK: - Functions

    func navigate(to step: Step) -> FlowContributors {
        guard let step = transform(step: step) as? RootStep else {
            return .none
        }
        switch step {
        case .main:
            return summonMainWindow()
        case .welcome:
            return summonWelcomeWindow()
        case .dimissWelcome:
            return dismissWelcomeWindow()
        }
    }

    private func transform(step: Step) -> Step? {
        if let welcomeStep = step as? WelcomeStep {
            switch welcomeStep {
            case .dismiss:
                return RootStep.dimissWelcome
            default:
                return nil
            }
        }
        return step
    }
}

private extension RootFlow {

    func summonMainWindow() -> FlowContributors {
        let mainFlow = MainFlow(services: services)

        Flows.use(mainFlow, when: .ready) { [rootWindow] (mainRoot: UITabBarController) in
            rootWindow.rootViewController = mainRoot
            rootWindow.makeKeyAndVisible()
        }
        return .one(flowContributor: .contribute(withNextPresentable: mainFlow, withNextStepper: MainStepper()))
    }

    func summonWelcomeWindow() -> FlowContributors {
        let welcomeFlow = WelcomeFlow()
        Flows.use(welcomeFlow, when: .ready) { [rootWindow] (welcomeRoot) in
            rootWindow.rootViewController = welcomeRoot
            rootWindow.makeKeyAndVisible()
        }
        return .one(flowContributor: .contribute(withNextPresentable: welcomeFlow, withNextStepper: WelcomeStepper()))
    }

    func dismissWelcomeWindow() -> FlowContributors {
        let mainFlow = MainFlow(services: services)
        Flows.use(mainFlow, when: .ready) { [rootWindow] (mainRoot: UITabBarController) in
            UIView.animate(withDuration: 0.2, animations: {
                rootWindow.alpha = 0
            }, completion: { _ in
                rootWindow.rootViewController = mainRoot
                rootWindow.makeKeyAndVisible()
                rootWindow.alpha = 1
            })
        }

        return .one(flowContributor: .contribute(withNextPresentable: mainFlow, withNextStepper: MainStepper()))
    }
}
