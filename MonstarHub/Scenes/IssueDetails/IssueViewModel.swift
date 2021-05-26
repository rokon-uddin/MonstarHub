//
//  IssueViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MessageKit
import Domain

class IssueViewModel: ViewModel, InputOutType {

    struct Input {
        let headerRefresh: Observable<Void>
        let userSelected: Observable<User>
        let mentionSelected: Observable<String>
    }

    struct Output {
        let userSelected: Observable<User>
    }

    let repository: BehaviorRelay<Repository>
    let issue: BehaviorRelay<Issue>
    typealias Services = AppServices
    let services: Services

    init(repository: Repository, issue: Issue, services: Services) {
        self.repository = BehaviorRelay(value: repository)
        self.issue = BehaviorRelay(value: issue)
        self.services = services
    }

    func transform(input: Input) -> Output {
        let userSelected = Observable.of(input.userSelected, input.mentionSelected.map({ (mention) -> User in
            var user = User()
            user.login = mention.removingPrefix("@")
            return user
        }) ).merge()

        return Output(userSelected: userSelected)
    }

    func issueCommentsViewModel() -> IssueCommentsViewModel {
        let viewModel = IssueCommentsViewModel(repository: repository.value, issue: issue.value, services: services)
        return viewModel
    }
}
