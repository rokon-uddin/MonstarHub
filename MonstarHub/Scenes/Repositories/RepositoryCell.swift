//
//  RepositoryCell.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import Domain

class RepositoryCell: DefaultTableViewCell {

    lazy var starButton: Button = {
        let view = Button()
        view.borderColor = .white
        view.borderWidth = Constants.Dimensions.borderWidth
        view.tintColor = .white
        view.cornerRadius = 17
        view.snp.remakeConstraints({ (make) in
            make.size.equalTo(34)
        })
        return view
    }()

    override func makeUI() {
        super.makeUI()
        stackView.insertArrangedSubview(starButton, at: 2)
    }

    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? RepositoryCellViewModel else { return }

        viewModel.hidesStarButton.asDriver().drive(starButton.rx.isHidden).disposed(by: rx.disposeBag)
        viewModel.starring.asDriver().map { (starred) -> UIImage? in
            let image = starred ? R.image.icon_button_unstar() : R.image.icon_button_star()
            return image?.template
            }.drive(starButton.rx.image()).disposed(by: rx.disposeBag)
        viewModel.starring.map { $0 ? 1.0: 0.6 }.asDriver(onErrorJustReturn: 0).drive(starButton.rx.alpha).disposed(by: rx.disposeBag)
    }
}
