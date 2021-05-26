//
//  SegmentedControl.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import HMSegmentedControl

class SegmentedControl: HMSegmentedControl {

    let segmentSelection = BehaviorRelay<Int>(value: 0)

    init() {
        super.init(sectionTitles: [])
        makeUI()
    }

    override init(sectionTitles sectiontitles: [String]) {
        super.init(sectionTitles: sectiontitles)
        makeUI()
    }

    override init(sectionImages: [UIImage], sectionSelectedImages: [UIImage]) {
        super.init(sectionImages: sectionImages, sectionSelectedImages: sectionSelectedImages)
        makeUI()
    }

    override init(sectionImages: [UIImage], sectionSelectedImages: [UIImage], titlesForSections sectionTitles: [String]) {
        super.init(sectionImages: sectionImages, sectionSelectedImages: sectionSelectedImages, titlesForSections: sectionTitles)
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
        themeService.attrsStream.subscribe(onNext: { [weak self] (theme) in
            self?.backgroundColor = theme.primary
            self?.selectionIndicatorColor = theme.secondary
            let font = UIFont.systemFont(ofSize: 11)
//            self?.titleTextAttributes = [NSAttributedString.Key.font: font,
//                                         NSAttributedString.Key.foregroundColor: theme.text]
            self?.selectedTitleTextAttributes = [NSAttributedString.Key.font: font,
                                                 NSAttributedString.Key.foregroundColor: theme.secondary]
            self?.setNeedsDisplay()
        }).disposed(by: rx.disposeBag)

        cornerRadius = Constants.Dimensions.cornerRadius
        imagePosition = .aboveText
        selectionStyle = .box
        selectionIndicatorLocation = .bottom
        selectionIndicatorBoxOpacity = 0
        selectionIndicatorHeight = 2.0
        segmentEdgeInset = UIEdgeInsets(inset: self.inset)
        indexChangeBlock = { [weak self] index in
            self?.segmentSelection.accept(Int(index))
        }
        snp.makeConstraints { (make) in
            make.height.equalTo(Constants.Dimensions.segmentedControlHeight)
        }
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
