//
//  IssueViewController.swift
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

class IssueViewController: ViewController {

    let conversationVC = IssueCommentsViewController()

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
        guard let viewModel = viewModel as? IssueViewModel else { return }
        conversationVC.viewModel = viewModel.issueCommentsViewModel()
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
        guard let viewModel = viewModel as? IssueViewModel else { return }

        let refresh = Observable.of(Observable.just(())).merge()
        let input = IssueViewModel.Input(headerRefresh: refresh,
                                         userSelected: conversationVC.senderSelected.map { $0 as? User}.filterNil(),
                                         mentionSelected: conversationVC.mentionSelected)
        let output = viewModel.transform(input: input)

        // TODO: Fix navigation
        output.userSelected.subscribe(onNext: { [weak self] (_) in
//            self?.navigator.show(segue: .userDetails(viewModel: viewModel), sender: self)
        }).disposed(by: rx.disposeBag)

        conversationVC.urlSelected.subscribe(onNext: { [weak self] (_) in
//            self?.navigator.show(segue: .webController(url), sender: self)
        }).disposed(by: rx.disposeBag)
    }
}
