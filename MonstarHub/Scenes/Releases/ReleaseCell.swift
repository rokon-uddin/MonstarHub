//
//  ReleaseCell.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit

class ReleaseCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        secondDetailLabel.numberOfLines = 0
    }

    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? ReleaseCellViewModel else { return }

        leftImageView.rx.tap().map { _ in viewModel.release.author }.filterNil()
            .bind(to: viewModel.userSelected).disposed(by: cellDisposeBag)
    }
}
