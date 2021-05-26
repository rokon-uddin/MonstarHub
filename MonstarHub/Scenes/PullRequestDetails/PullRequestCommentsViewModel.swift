//
//  PullRequestCommentsViewModel.swift
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

class PullRequestCommentsViewModel: ViewModel, InputOutType {

    struct Input {
        let headerRefresh: Observable<Void>
        let sendSelected: Observable<String>
    }

    struct Output {
        let items: Observable<[Comment]>
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

        let comments = input.headerRefresh.flatMapLatest { () -> Observable<[Comment]> in
            let fullname = self.repository.value.fullname ?? ""
            let issueNumber = self.pullRequest.value.number ?? 0
            return self.services.gitHubUseCase
                .issueComments(fullname: fullname, number: issueNumber, page: self.page)
                .trackActivity(self.loading)
                .trackError(self.error)
        }

        input.sendSelected.subscribe(onNext: { (text) in
            logDebug(text)
        }).disposed(by: rx.disposeBag)

        return Output(items: comments)
    }
}
