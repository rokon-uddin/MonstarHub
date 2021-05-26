//
//  FlatButton.swift
//  MonstarHub
//
//  Created by Rokon on 2/5/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit

public class FlatButton: UIButton {

    init() {
        super.init(frame: .zero)
        makeUI()
    }
    private var h: CGFloat?
    init(height: CGFloat) {
        self.h = height
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        makeUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        themeService.rx
//            .bind({ $0.flatButtonTitle }, to: rx.titleColor(for: .normal))
            .bind({ UIImage(color: $0.background, size: CGSize(width: 1, height: 1)) }, to: rx.backgroundImage(for: .normal))
            .bind({ UIImage(color: $0.background, size: CGSize(width: 1, height: 1)) }, to: rx.backgroundImage(for: .highlighted))
            .bind({ $0.primary.withAlphaComponent(0.8) }, to: rx.titleColor(for: .highlighted))
            .bind({ UIImage(color: $0.background.withAlphaComponent(0.6), size: CGSize(width: 1, height: 1)) }, to: rx.backgroundImage(for: .disabled))
            .disposed(by: rx.disposeBag)

        layer.masksToBounds = true
        titleLabel?.lineBreakMode = .byWordWrapping

        snp.makeConstraints { (make) in
            make.height.equalTo( h ?? Constants.Dimensions.buttonHeight)
        }

        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
