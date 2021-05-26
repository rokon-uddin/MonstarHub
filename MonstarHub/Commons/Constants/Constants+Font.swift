//
//  Constants+Font.swift
//  MonstarHub
//
//  Created by Rokon on 2/5/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit

extension Constants {
    enum TextStyle {
        case title, subTitle, subTitleBold, body, bodyBold, bodySmall, allCaps, allCapsBold

        public var font: UIFont {
            switch self {
            case .title:
                return UIFont.systemFont(ofSize: 18, weight: .regular)
            case .subTitle:
                return UIFont.systemFont(ofSize: 16, weight: .regular)
            case .subTitleBold:
                return UIFont.systemFont(ofSize: 16, weight: .bold)
            case .body:
                return UIFont.systemFont(ofSize: 14, weight: .regular)
            case .bodyBold:
                return UIFont.systemFont(ofSize: 14, weight: .bold)
            case .bodySmall:
                return UIFont.systemFont(ofSize: 12, weight: .regular)
            case .allCaps:
                return UIFont.systemFont(ofSize: 10, weight: .regular)
            case .allCapsBold:
                return UIFont.systemFont(ofSize: 10, weight: .regular)
            }
        }
    }
}
