//
//  ImageView.swift
//  MonstarHub
//
//  Created by Rokon on 1/4/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit

class ImageView: UIImageView {

    init() {
        super.init(frame: .zero)
        makeUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    override init(image: UIImage?) {
        super.init(image: image)
        makeUI()
    }

    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        tintColor = .primary()
        layer.masksToBounds = true
        contentMode = .center

        hero.modifiers = [.arc]

        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
