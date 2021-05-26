//
//  ThemeViewController.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let reuseIdentifier = R.reuseIdentifier.themeCell.identifier

class ThemeViewController: TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        navigationTitle = R.string.localizable.themeNavigationTitle.key.localized()
        tableView.register(R.nib.themeCell)
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? ThemeViewModel else { return }

        let input = ThemeViewModel.Input(refresh: Observable.just(()),
                                         selection: tableView.rx.modelSelected(ThemeCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        output.items
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: ThemeCell.self)) { _, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)

        // TODO: Fix it
        output.selected.drive(onNext: { [weak self] (_) in
//            self?.navigator.dismiss(sender: self)
        }).disposed(by: rx.disposeBag)
    }
}
