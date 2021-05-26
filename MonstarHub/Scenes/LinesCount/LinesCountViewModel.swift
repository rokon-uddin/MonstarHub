//
//  LinesCountViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Domain

class LinesCountViewModel: ViewModel, InputOutType {

    struct Input {
        let refresh: Observable<Void>
    }

    struct Output {
        let items: Driver<[LanguageLines]>
    }

    let repository: BehaviorRelay<Repository>
    typealias Services = AppServices
    let services: Services
    init(repository: Repository, services: Services) {
        self.repository = BehaviorRelay(value: repository)
        self.services = services

        if let fullname = repository.fullname {
            analytics.log(.linesCount(fullname: fullname))
        }
    }

    func transform(input: Input) -> Output {

        let elements = input.refresh.flatMapLatest { () -> Observable<[LanguageLines]> in
            let fullname = self.repository.value.fullname ?? ""
            return self.services.codeTabsUseCase
                .numberOfLines(fullname: fullname)
                .trackActivity(self.loading)
                .trackError(self.error)
        }.asDriver(onErrorJustReturn: [])

        return Output(items: elements)
    }

    func color(for language: String) -> String? {
        guard let language = repository.value.languages?.languages.filter({ $0.name == language }).first else {
            return nil
        }
        return language.color
    }
}
