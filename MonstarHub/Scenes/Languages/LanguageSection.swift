//
//  LanguageSection.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxDataSources

enum LanguageSection {
    case languages(title: String, items: [LanguageSectionItem])
}

enum LanguageSectionItem {
    case languageItem(cellViewModel: RepoLanguageCellViewModel)
}

extension LanguageSection: SectionModelType {
    typealias Item = LanguageSectionItem

    var title: String {
        switch self {
        case .languages(let title, _): return title
        }
    }

    var items: [LanguageSectionItem] {
        switch  self {
        case .languages(_, let items): return items.map {$0}
        }
    }

    init(original: LanguageSection, items: [Item]) {
        switch original {
        case .languages(let title, let items): self = .languages(title: title, items: items)
        }
    }
}
