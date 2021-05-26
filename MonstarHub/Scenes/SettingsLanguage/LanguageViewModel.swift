//
//  LanguageViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Localize_Swift

class LanguageViewModel: ViewModel, InputOutType {

    struct Input {
        let trigger: Observable<Void>
        let saveTrigger: Driver<Void>
        let selection: Driver<LanguageCellViewModel>
    }

    struct Output {
        let items: Driver<[LanguageCellViewModel]>
        let saved: Driver<Void>
    }

    private var currentLanguage: BehaviorRelay<String>
    typealias Services = AppServices
    let services: Services

    init(services: Services) {
        currentLanguage = BehaviorRelay(value: Localize.currentLanguage())
        self.services = services
        super.init()
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[LanguageCellViewModel]>(value: [])

        input.trigger.map({ () -> [LanguageCellViewModel] in
            let languages = Localize.availableLanguages(true)
            return languages.map({ (language) -> LanguageCellViewModel in
                let viewModel = LanguageCellViewModel(with: language)
                return viewModel
            })
        }).bind(to: elements).disposed(by: rx.disposeBag)

        let saved = input.saveTrigger.map { () -> Void in
            let language = self.currentLanguage.value
            Localize.setCurrentLanguage(language)
            analytics.log(.appLanguage(language: language))
        }

        input.selection.drive(onNext: { (cellViewModel) in
            let language = cellViewModel.language
            self.currentLanguage.accept(language)
        }).disposed(by: rx.disposeBag)

        return Output(items: elements.asDriver(),
                      saved: saved.asDriver(onErrorJustReturn: ()))
    }
}
