//
//  RepoLanguageCellViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

class RepoLanguageCellViewModel: DefaultTableViewCellViewModel {

    let language: Language

    init(with language: Language) {
        self.language = language
        super.init()
        title.accept(language.displayName)
    }
}
