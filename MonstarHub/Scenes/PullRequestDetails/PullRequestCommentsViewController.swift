//
//  PullRequestCommentsViewController.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MessageKit

class PullRequestCommentsViewController: ChatViewController {

    var viewModel: PullRequestCommentsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func bindViewModel() {
        super.bindViewModel()

        let refresh = Observable.of(Observable.just(()), themeService.attrsStream.mapToVoid()).merge()
        let input = PullRequestCommentsViewModel.Input(headerRefresh: refresh,
                                                 sendSelected: sendPressed)
        let output = viewModel.transform(input: input)

        output.items.subscribe(onNext: { [weak self] (comments) in
            self?.messages = comments
        }).disposed(by: rx.disposeBag)

        viewModel.error.asDriver().drive(onNext: { [weak self] (error) in
            self?.showAlert(title: R.string.localizable.commonError.key.localized(), message: error.localizedDescription)
        }).disposed(by: rx.disposeBag)
    }
}
