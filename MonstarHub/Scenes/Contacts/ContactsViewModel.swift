//
//  ContactsViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import Domain

class ContactsViewModel: ViewModel, InputOutType {

    struct Input {
        let cancelTrigger: Driver<Void>
        let cancelSearchTrigger: Driver<Void>
        let trigger: Observable<Void>
        let keywordTrigger: Driver<String>
        let selection: Driver<ContactCellViewModel>
    }

    struct Output {
        let items: Driver<[ContactCellViewModel]>
        let cancelSearchEvent: Driver<Void>
        let contactSelected: Driver<Contact>
    }

    let keyword = BehaviorRelay<String>(value: "")
    let contactSelected = PublishSubject<Contact>()

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[ContactCellViewModel]>(value: [])

        let refresh = Observable.of(input.trigger, keyword.mapToVoid()).merge()

        input.keywordTrigger.skip(1).throttle(DispatchTimeInterval.milliseconds(300)).distinctUntilChanged().asObservable().bind(to: keyword).disposed(by: rx.disposeBag)

        refresh.flatMapLatest({ [weak self] () -> Observable<[ContactCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            return ContactsManager.default.getContacts(with: self.keyword.value)
                .trackActivity(self.loading)
                .trackError(self.error)
                .map { $0.map({ (contact) -> ContactCellViewModel in
                    let viewModel = ContactCellViewModel(with: contact)
                    return viewModel
                })
            }
        }).subscribe(onNext: { (items) in
            elements.accept(items)
        }, onError: { (error) in
            logError(error.localizedDescription)
        }).disposed(by: rx.disposeBag)

        let cancelSearchEvent = input.cancelSearchTrigger

        input.selection.map { $0.contact }.asObservable().bind(to: contactSelected).disposed(by: rx.disposeBag)

        return Output(items: elements.asDriver(),
                      cancelSearchEvent: cancelSearchEvent,
                      contactSelected: contactSelected.asDriver(onErrorJustReturn: Contact()))
    }
}
