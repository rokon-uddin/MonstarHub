//
//  CommitsViewController.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = R.reuseIdentifier.commitCell.identifier

class CommitsViewController: TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        tableView.register(R.nib.commitCell)
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? CommitsViewModel else { return }

        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let input = CommitsViewModel.Input(headerRefresh: refresh,
                                           footerRefresh: footerRefreshTrigger,
                                           selection: tableView.rx.modelSelected(CommitCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        output.navigationTitle.drive(onNext: { [weak self] (title) in
            self?.navigationTitle = title
        }).disposed(by: rx.disposeBag)

        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: CommitCell.self)) { _, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)

        output.commitSelected.drive(onNext: { url in
            if let url  = url {
                viewModel.navigateTo(step: SearchStep.webController(url))
            }
        }).disposed(by: rx.disposeBag)

        output.userSelected.drive(onNext: { user in
            viewModel.navigateTo(step: SearchStep.userDetails(user: user))
        }).disposed(by: rx.disposeBag)
    }
}
