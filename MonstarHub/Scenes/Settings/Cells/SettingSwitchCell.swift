//
//  SettingSwitchCell.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit

class SettingSwitchCell: DefaultTableViewCell {

    lazy var switchView: Switch = {
        let view = Switch()
        return view
    }()

    override func makeUI() {
        super.makeUI()
        leftImageView.contentMode = .center
        leftImageView.cornerRadius = 0
        leftImageView.snp.updateConstraints { (make) in
            make.size.equalTo(30)
        }
        stackView.insertArrangedSubview(switchView, at: 2)
        themeService.rx
            .bind({ $0.secondary }, to: leftImageView.rx.tintColor)
            .disposed(by: rx.disposeBag)
    }

    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? SettingSwitchCellViewModel else { return }

        viewModel.isEnabled.asDriver().drive(switchView.rx.isOn).disposed(by: rx.disposeBag)
        switchView.rx.isOn.bind(to: viewModel.switchChanged).disposed(by: rx.disposeBag)
    }
}
