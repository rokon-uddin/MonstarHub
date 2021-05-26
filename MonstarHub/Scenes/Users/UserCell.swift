//
//  UserCell.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit

class UserCell: DefaultTableViewCell {

    lazy var followButton: Button = {
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
        stackView.insertArrangedSubview(followButton, at: 2)
    }

    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? UserCellViewModel else { return }

        viewModel.hidesFollowButton.asDriver().drive(followButton.rx.isHidden).disposed(by: rx.disposeBag)
        viewModel.following.asDriver().map { (followed) -> UIImage? in
            let image = followed ? R.image.icon_button_user_x() : R.image.icon_button_user_plus()
            return image?.template
            }.drive(followButton.rx.image()).disposed(by: rx.disposeBag)
        viewModel.following.map { $0 ? 1.0: 0.6 }.asDriver(onErrorJustReturn: 0).drive(followButton.rx.alpha).disposed(by: rx.disposeBag)
    }
}
