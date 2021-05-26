//
//  JobsStepper.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxCocoa
import RxFlow
import Domain

enum SearchStep: Step {
    case list
    case languages
    case userDetails(user: User)
    case repositoryDetails(repository: Repository)
    case dismissChildFlow

    // RepositorySectionItem
    case parentItem(value: Repository)
    case sizeItem(value: Repository)
    case createdItem(value: Repository)
    case updatedItem(value: Repository)
    case issuesItem(value: Repository)
    case pullRequestsItem(value: Repository)
    case commitsItem(value: Repository)
    case branchesItem(value: Repository)
    case releasesItem(value: Repository)
    case contributorsItem(value: UsersMode)
    case notificationsItem(value: NotificationsMode)
    case sourceItem(value: Repository, ref: String)
    case countLinesOfCodeItem(value: Repository)
    case contents(repository: Repository, content: Content?, ref: String?)

    // User
    case starsItem(value: RepositoriesMode)
    case watchingItem(value: RepositoriesMode)
    case companyItem(value: User)
    case repositoryItem(value: Repository)
    case organizationItem(value: User)

    // Common
    case webController(URL)
    case eventsItem(value: EventsMode)

    case safari(URL)

    case issueDetails(value: Repository, issue: Issue)
    case pullRequestDetails(value: Repository, pullRequest: PullRequest)

    case repositories(mode: RepositoriesMode)
    case users(mode: UsersMode)

    case source(content: Content)

}

final class SearchStepper: Stepper {

    var steps = PublishRelay<Step>()

    var initialStep: Step {
        SearchStep.list
    }
}
