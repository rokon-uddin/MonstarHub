//
//  TextField.swift
//  MonstarHub
//
//  Created by Rokon on 1/4/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit

class TextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    override var placeholder: String? {
        didSet {
            themeService.switch(themeService.type)
        }
    }

    func makeUI() {
        themeService.rx
            .bind({ $0.text }, to: rx.textColor)
            .bind({ $0.secondary }, to: rx.tintColor)
            .bind({ $0.textGray }, to: rx.placeholderColor)
            .bind({ $0.text }, to: rx.borderColor)
            .bind({ $0.keyboardAppearance }, to: rx.keyboardAppearance)
            .disposed(by: rx.disposeBag)

        layer.masksToBounds = true
        borderWidth = Constants.Dimensions.borderWidth
        cornerRadius = Constants.Dimensions.cornerRadius

        snp.makeConstraints { (make) in
            make.height.equalTo(Constants.Dimensions.textFieldHeight)
        }
    }
}
