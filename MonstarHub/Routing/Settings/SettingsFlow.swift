//
//  SettingsFlow.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxFlow
import RxCocoa
import RxSwift
import Domain
import AcknowList
import WhatsNewKit

final class SettingsFlow: Flow {

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
        guard let step = step as? SettingsStep else {
            return .none
        }
        switch step {
        case .list:
            return summonAccountController()
        case .dismissChildFlow:
            return dismissChildFlow()
        case .userDetails(let user):
            return summonUserController(user)
        case .theme:
            return summonThemeController()
        case .language:
            return summonLanguagesController()
        case .contacts:
            return summonContactsController()
        case .repositoryDetails(let value):
            return summonRepositoryController(value)
        case .acknowledgementsItem:
            return summonAcknowListController()
        case .whatsNewItem(let block):
            return summonWhatsNewController(block)
        }
    }
}

private extension SettingsFlow {

    func summonAccountController() -> FlowContributors {
        let viewModel = SettingsViewModel(services: services)
        let viewController = SettingsViewController(viewModel: viewModel)
        rootViewController.setViewControllers([viewController], animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonUserController(_ user: User) -> FlowContributors {
        let viewModel = UserViewModel(user: user, services: services)
        let viewController = UserViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonRepositoryController(_ repository: Repository) -> FlowContributors {
        let viewModel = RepositoryViewModel(repository: repository, services: services)
        let viewController = RepositoryViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonLanguagesController() -> FlowContributors {
        let viewModel = LanguageViewModel(services: services)
        let viewController = LanguageViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .none
    }

    func summonThemeController() -> FlowContributors {
        let viewModel = ThemeViewModel()
        let viewController = ThemeViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .none
    }

    func summonContactsController() -> FlowContributors {
        let viewModel = ContactsViewModel()
        let viewController = ContactsViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .none
    }

    func summonAcknowListController() -> FlowContributors {
        let path = Bundle.main.path(forResource: "Pods-MonstarHub-acknowledgements", ofType: "plist")
        let viewController = AcknowListViewController(acknowledgementsPlistPath: path)
        rootViewController.pushViewController(viewController)
        return .none
    }

    func summonWhatsNewController(_ block: WhatsNewBlock) -> FlowContributors {
        var viewController: UIViewController?
        if let versionStore = block.2 {
            viewController = WhatsNewViewController(whatsNew: block.0, configuration: block.1, versionStore: versionStore)
        } else {
            viewController = WhatsNewViewController(whatsNew: block.0, configuration: block.1)
        }

        if let vc = viewController {
            rootViewController.present(vc, animated: true) { }
        }
        return .none
    }

    func dismissChildFlow() -> FlowContributors {
        rootViewController.presentedViewController?.dismiss(animated: true, completion: nil)
        return .none
    }
}
