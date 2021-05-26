//
//  ThemeCellViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ThemeCellViewModel: DefaultTableViewCellViewModel {

    let imageColor = BehaviorRelay<UIColor?>(value: nil)

    let theme: ColorTheme

    init(with theme: ColorTheme) {
        self.theme = theme
        super.init()
        title.accept(theme.title)
        imageColor.accept(theme.color)
    }
}
