//
//  PullRequestViewController.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MessageKit
import Domain

class PullRequestViewController: ViewController {

    let conversationVC = PullRequestCommentsViewController()

    /// Required for the `MessageInputBar` to be visible
    override var canBecomeFirstResponder: Bool {
        return conversationVC.canBecomeFirstResponder
    }

    /// Required for the `MessageInputBar` to be visible
    override var inputAccessoryView: UIView? {
        return conversationVC.inputAccessoryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //        bannerView.isHidden = true

        /// Add the `ConversationViewController` as a child view controller
        guard let viewModel = viewModel as? PullRequestViewModel else { return }
        conversationVC.viewModel = viewModel.pullRequestCommentsViewModel()
        conversationVC.willMove(toParent: self)
        addChild(conversationVC)
        stackView.addArrangedSubview(conversationVC.view)
        conversationVC.didMove(toParent: self)
    }

    override func makeUI() {
        super.makeUI()

        navigationController?.hero.isEnabled = false
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? PullRequestViewModel else { return }

        let refresh = Observable.of(Observable.just(())).merge()
        let input = PullRequestViewModel.Input(headerRefresh: refresh,
                                               userSelected: conversationVC.senderSelected.map { $0 as? User}.filterNil(),
                                               mentionSelected: conversationVC.mentionSelected)
        let output = viewModel.transform(input: input)

        output.userSelected.subscribe(onNext: { [weak self] user in
            self?.viewModel.navigateTo(step: SearchStep.userDetails(user: user))
        }).disposed(by: rx.disposeBag)

        conversationVC.urlSelected.subscribe(onNext: { [weak self] url in
            self?.viewModel.navigateTo(step: SearchStep.webController(url))
        }).disposed(by: rx.disposeBag)
    }
}
