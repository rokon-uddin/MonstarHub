//
//  Toolbar.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit

class Toolbar: UIToolbar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        isTranslucent = false

        themeService.rx
            .bind({ $0.barStyle }, to: rx.barStyle)
            .bind({ $0.primary }, to: rx.barTintColor)
            .bind({ $0.secondary }, to: rx.tintColor)
            .disposed(by: rx.disposeBag)

        snp.makeConstraints { (make) in
            make.height.equalTo(Constants.Dimensions.tableRowHeight)
        }
    }
}
