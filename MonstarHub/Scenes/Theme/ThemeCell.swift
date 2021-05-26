//
//  ThemeCell.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit

class ThemeCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        rightImageView.isHidden = true
    }

    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? ThemeCellViewModel else { return }

        viewModel.imageColor.asDriver().drive(leftImageView.rx.backgroundColor).disposed(by: rx.disposeBag)
    }
}
