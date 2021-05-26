//
//  SectionType.swift
//  MonstarHub
//
//  Created by Rokon on 1/24/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionType<T> {
    var header: String
    var items: [T]
}

extension SectionType: SectionModelType {
    typealias Item = T

    init(original: SectionType, items: [T]) {
        self = original
        self.items = items
    }
}
