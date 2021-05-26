//
//  LanguagesViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Domain

class LanguagesViewModel: ViewModel, InputOutType {

    struct Input {
        let trigger: Observable<Void>
        let saveTrigger: Driver<Void>
        let keywordTrigger: Driver<String>
        let allTrigger: Driver<Void>
        let selection: Driver<LanguageSectionItem>
    }

    struct Output {
        let items: Driver<[LanguageSection]>
        let selectedRow: Driver<IndexPath?>
        let dismiss: Driver<Void>
    }

    let currentLanguage: BehaviorRelay<Language?>
    let languages: BehaviorRelay<[Language]>
    var selectedIndexPath: IndexPath?
    typealias Services = AppServices
    let services: Services

    init(currentLanguage: Language?, languages: [Language], services: Services) {
        self.currentLanguage = BehaviorRelay(value: currentLanguage)
        self.languages = BehaviorRelay(value: languages)
        self.services = services
        super.init()
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[LanguageSection]>(value: [])

        let selectedLanguage = BehaviorRelay<Language?>(value: nil)

        Observable.combineLatest(languages, input.keywordTrigger.asObservable())
            .map({ (languages, keyword) -> [LanguageSection] in
                var elements: [LanguageSection] = []

                let languages = languages.filtered({ (language) -> Bool in
                    if keyword.isEmpty { return true }
                    return language.displayName.contains(keyword, caseSensitive: false)
                }, map: { (language) -> LanguageSectionItem in
                    let cellViewModel = RepoLanguageCellViewModel(with: language)
                    return LanguageSectionItem.languageItem(cellViewModel: cellViewModel)
                })

                let title = R.string.localizable.languagesAllSectionTitle.key.localized()
                elements.append(LanguageSection.languages(title: title, items: languages))
                return elements
        }).bind(to: elements).disposed(by: rx.disposeBag)

        let saved = input.saveTrigger.map { () -> Void in
            let language = selectedLanguage.value
            self.currentLanguage.accept(language)
            language?.save()
            if let language = language?.name {
                analytics.log(.repoLanguage(language: language))
            }
        }

        let allTriggered = input.allTrigger
        allTriggered.drive(onNext: { () in
            self.currentLanguage.accept(nil)
            Language.removeCurrentLanguage()
            analytics.log(.repoLanguage(language: "All"))
        }).disposed(by: rx.disposeBag)

        input.selection.drive(onNext: { (item) in
            switch item {
            case .languageItem(let cellViewModel):
                selectedLanguage.accept(cellViewModel.language)
            }
        }).disposed(by: rx.disposeBag)

        let selectedRow = elements.map { (items) -> IndexPath? in
            guard let currentLanguage = self.currentLanguage.value else { return nil }
            for (section, item) in items.enumerated() {
                for (row, item) in item.items.enumerated() {
                    switch item {
                    case .languageItem(let cellViewModel):
                        if currentLanguage == cellViewModel.language {
                            return IndexPath(row: row, section: section)
                        }
                    }
                }
            }
            return nil
        }.asDriver(onErrorJustReturn: nil)

        let dismiss = Observable.of(saved.asObservable(), allTriggered.asObservable()).merge()

        return Output(items: elements.asDriver(),
                      selectedRow: selectedRow,
                      dismiss: dismiss.asDriver(onErrorJustReturn: ()))
    }
}
