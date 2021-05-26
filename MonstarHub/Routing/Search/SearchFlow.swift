//
//  SearchFlow.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxFlow
import RxCocoa
import RxSwift
import Domain

final class SearchFlow: Flow {

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
        guard let step = step as? SearchStep else {
            return .none
        }
        switch step {
        case .list:
            return summonSearchController()
        case .languages:
            return summonLanguagesController()
        case .userDetails(let user):
            return summonUserController(user)
        case .repositoryDetails(let repository):
            return summonRepositoryController(repository)
        case .dismissChildFlow:
            return dismissChildFlow()

        // RepositorySectionItem
        case .parentItem(let value):
            return summonRepositoryController(value)
        case .issuesItem(let value):
            return summonIssuesController(value)
        case .pullRequestsItem(let value):
            return summonPullRequestsController(value)
        case .commitsItem(let value):
            return summonCommitsController(value)
        case .branchesItem(let value):
            return summonBranchesController(value)
        case .releasesItem(let value):
            return summonReleasesController(value)
        case .contributorsItem(let value):
            return summonContributorsController(value)
        case .eventsItem(let value):
            return summonEventsController(value)
        case .notificationsItem(let value):
            return summonNotificationsController(value)
        case .sourceItem(let value, let ref):
            return summonSourceController(value, content: nil, ref: ref)
        case .countLinesOfCodeItem(let value):
            return summonLinesOfCodeController(value)
        case .webController(let url):
            return summonWebController(url: url)
        case .contents(let repository, let content, let ref):
            return summonSourceController(repository, content: content, ref: ref)

        // User
        case .starsItem(let value):
            return summonRepositoriesController(value)
        case .watchingItem(let value):
            return summonRepositoriesController(value)
        case .companyItem(let value):
            return summonUserController(value)
        case .repositoryItem(let value):
            return summonRepositoryController(value)
        case .organizationItem(let value):
            return summonUserController(value)
        case .safari(let url):
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return .none
        case .issueDetails(let value, let issue):
            return summonIssueController(repository: value, issue: issue)
        case .pullRequestDetails(let value, let pullRequest):
            return summonPullRequestController(repository: value, pullRequest: pullRequest)
        case .repositories(let mode):
            return summonRepositoriesController(mode)
        case .users(let mode):
            return summonUsersController(mode: mode)

        case .source(let content):
            return summonSourceController(content)
        default:
            return .none
        }
    }
}

private extension SearchFlow {

    func summonSearchController() -> FlowContributors {
        let viewModel = SearchViewModel(services: services)
        let viewController = SearchViewController(viewModel: viewModel)
        rootViewController.setViewControllers([viewController], animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonLanguagesController() -> FlowContributors {
        let viewModel = LanguageViewModel(services: services)
        let viewController = LanguageViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .none
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

    func summonWebController(url: URL) -> FlowContributors {
        let viewController = WebViewController(viewModel: nil)
        viewController.load(url: url)
        rootViewController.present(viewController, animated: true) {}
        return .none
    }

    func summonIssuesController(_ repository: Repository) -> FlowContributors {

        let viewModel = IssuesViewModel(repository: repository, services: services)
        let viewController = IssuesViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonPullRequestsController(_ repository: Repository) -> FlowContributors {

        let viewModel = PullRequestsViewModel(repository: repository, services: services)
        let viewController = PullRequestViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonCommitsController(_ repository: Repository) -> FlowContributors {

        let viewModel = CommitsViewModel(repository: repository, services: services)
        let viewController = CommitsViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonBranchesController(_ repository: Repository) -> FlowContributors {

        let viewModel = BranchesViewModel(repository: repository, services: services)
        let viewController = BranchesViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonReleasesController(_ repository: Repository) -> FlowContributors {

        let viewModel = ReleasesViewModel(repository: repository, services: services)
        let viewController = ReleasesViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonContributorsController(_ user: UsersMode) -> FlowContributors {

        let viewModel = UsersViewModel(mode: user, services: services)
        let viewController = UsersViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonEventsController(_ event: EventsMode) -> FlowContributors {

        let viewModel = EventsViewModel(mode: event, services: services)
        let viewController = EventsViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonNotificationsController(_ mode: NotificationsMode) -> FlowContributors {

        let viewModel = NotificationsViewModel(mode: mode, services: services)
        let viewController = NotificationsViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonSourceController(_ repository: Repository, content: Content?, ref: String?) -> FlowContributors {

        let viewModel = ContentsViewModel(repository: repository, content: content, ref: ref, services: services)
        let viewController = ContentsViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonLinesOfCodeController(_ repository: Repository) -> FlowContributors {

        let viewModel = LinesCountViewModel(repository: repository, services: services)
        let viewController = LinesCountViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonRepositoriesController(_ mode: RepositoriesMode) -> FlowContributors {

        let viewModel = RepositoriesViewModel(mode: mode, services: services)
        let viewController = RepositoriesViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonIssueController(repository: Repository, issue: Issue) -> FlowContributors {

        let viewModel = IssueViewModel(repository: repository, issue: issue, services: services)
        let viewController = IssueViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonSourceController(_ content: Content) -> FlowContributors {

        let viewModel = SourceViewModel(content: content, services: services)
        let viewController = SourceViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonPullRequestController(repository: Repository, pullRequest: PullRequest) -> FlowContributors {
        let viewModel = PullRequestViewModel(repository: repository, pullRequest: pullRequest, services: services)
        let viewController = PullRequestViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func summonUsersController(mode: UsersMode) -> FlowContributors {
        let viewModel = UsersViewModel(mode: mode, services: services)
        let viewController = UsersViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }

    func dismissChildFlow() -> FlowContributors {
        rootViewController.presentedViewController?.dismiss(animated: true, completion: nil)
        return .none
    }
}
