//
//  ContentsViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Domain

class ContentsViewModel: ViewModel, InputOutType {

    struct Input {
        let headerRefresh: Observable<Void>
        let selection: Driver<ContentCellViewModel>
        let openInWebSelection: Observable<Void>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let items: BehaviorRelay<[ContentCellViewModel]>
        let openContents: Driver<(repository: Repository, content: Content?, ref: String?)>
        let openUrl: Driver<URL?>
        let openSource: Driver<Content>
    }

    let repository: BehaviorRelay<Repository>
    let content: BehaviorRelay<Content?>
    let ref: BehaviorRelay<String?>
    typealias Services = AppServices
    let services: Services

    init(repository: Repository, content: Content?, ref: String?, services: Services) {
        self.repository = BehaviorRelay(value: repository)
        self.content = BehaviorRelay(value: content)
        self.ref = BehaviorRelay(value: ref)
        self.services = services
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[ContentCellViewModel]>(value: [])

        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[ContentCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            return self.request()
                .trackActivity(self.headerLoading)
        }).subscribe(onNext: { (items) in
            elements.accept(items)
        }).disposed(by: rx.disposeBag)

        let openContents = input.selection.map { $0.content }.filter { $0.type == .dir }
            .map({ (content) -> (repository: Repository, content: Content?, ref: String?) in
                let repository = self.repository.value
                let ref = self.ref.value
                return (repository, content, ref)
            })

        let openUrl = input.openInWebSelection.map { self.content.value?.htmlUrl?.url }
            .filterNil().asDriver(onErrorJustReturn: nil)

        let content = input.selection.map { $0.content }.filter { $0.type != .dir }

        let navigationTitle = content.map({ (content) -> String in
            return content.name ?? self.repository.value.fullname ?? ""
        }).asDriver(onErrorJustReturn: "")

        return Output(navigationTitle: navigationTitle,
                      items: elements,
                      openContents: openContents,
                      openUrl: openUrl,
                      openSource: content)
    }

    func request() -> Observable<[ContentCellViewModel]> {
        let fullname = repository.value.fullname ?? ""
        let path = content.value?.path ?? ""
        let ref = self.ref.value
        return services.gitHubUseCase
            .contents(fullname: fullname, path: path, ref: ref)
            .trackActivity(loading)
            .trackError(error)
            .map { $0.sorted(by: { (lhs, rhs) -> Bool in
                if lhs.type == rhs.type {
                    return lhs.name?.lowercased() ?? "" < rhs.name?.lowercased() ?? ""
                } else {
                    return lhs.type > rhs.type
                }
            }).map { ContentCellViewModel(with: $0) } }
    }
}
