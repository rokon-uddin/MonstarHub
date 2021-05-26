//
//  PullRequestViewModel.swift
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

class PullRequestViewModel: ViewModel, InputOutType {

    struct Input {
        let headerRefresh: Observable<Void>
        let userSelected: Observable<User>
        let mentionSelected: Observable<String>
    }

    struct Output {
        let userSelected: Observable<User>
    }

    let repository: BehaviorRelay<Repository>
    let pullRequest: BehaviorRelay<PullRequest>
    typealias Services = AppServices
    private let services: Services

    init(repository: Repository, pullRequest: PullRequest, services: Services) {
        self.repository = BehaviorRelay(value: repository)
        self.pullRequest = BehaviorRelay(value: pullRequest)
        self.services = services
        super.init()
    }

    func transform(input: Input) -> Output {
        let userSelected = Observable.of(input.userSelected, input.mentionSelected.map({ (mention) -> User in
            var user = User()
            user.login = mention.removingPrefix("@")
            return user
        }) ).merge()

        return Output(userSelected: userSelected)
    }

    func pullRequestCommentsViewModel() -> PullRequestCommentsViewModel {
        let viewModel = PullRequestCommentsViewModel(repository: repository.value, pullRequest: pullRequest.value, services: services)
        return viewModel
    }
}
