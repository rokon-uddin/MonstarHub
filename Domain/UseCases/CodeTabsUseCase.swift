//
//  CodeTabsUseCase.swift
//  Domain
//
//  Created by Rokon on 5/28/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxSwift

public protocol CodeTabsUseCase {
    func numberOfLines(fullname: String) -> Single<[LanguageLines]>
}
