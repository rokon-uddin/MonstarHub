//
//  LanguagesCellViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

class LanguagesCellViewModel: NSObject {

    let languages: Languages?

    init(languages: Languages) {
        self.languages = languages
    }
}
