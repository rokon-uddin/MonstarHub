//
//  IssuesViewController.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Domain

private let reuseIdentifier = R.reuseIdentifier.issueCell.identifier

enum IssueSegments: Int {
    case open, closed

    var title: String {
        switch self {
        case .open: return R.string.localizable.issuesOpenSegmentTitle.key.localized()
        case .closed: return R.string.localizable.issuesClosedSegmentTitle.key.localized()
        }
    }

    var state: State {
        switch self {
        case .open: return .open
        case .closed: return .closed
        }
    }
}

class IssuesViewController: TableViewController {

    lazy var segmentedControl: SegmentedControl = {
        let items = [IssueSegments.open.title,
                     IssueSegments.closed.title]
        let view = SegmentedControl(sectionTitles: items)
        view.selectedSegmentIndex = 0
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(250)
        })
        return view
    }()

    lazy var ownerImageView: SlideImageView = {
        let view = SlideImageView()
        view.cornerRadius = 40
        return view
    }()

    lazy var headerView: View = {
        let view = View()
        view.hero.id = "TopHeaderId"
        view.addSubview(self.ownerImageView)
        self.ownerImageView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().inset(self.inset)
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(80)
        })
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        navigationItem.titleView = segmentedControl

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.segmentedControl.sectionTitles = [IssueSegments.open.title,
                                                    IssueSegments.closed.title]
        }).disposed(by: rx.disposeBag)

        themeService.rx
            .bind({ $0.primaryDark }, to: headerView.rx.backgroundColor)
            .disposed(by: rx.disposeBag)

        stackView.insertArrangedSubview(headerView, at: 0)

        tableView.register(R.nib.issueCell)
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? IssuesViewModel else { return }

        let segmentSelected = Observable.of(segmentedControl.segmentSelection.map { IssueSegments(rawValue: $0)! }).merge()
        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger, segmentSelected.mapToVoid().skip(1)).merge()
        let input = IssuesViewModel.Input(headerRefresh: refresh,
                                          footerRefresh: footerRefreshTrigger,
                                          segmentSelection: segmentSelected,
                                          selection: tableView.rx.modelSelected(IssueCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        output.navigationTitle.drive(onNext: { [weak self] (title) in
            self?.navigationTitle = title
        }).disposed(by: rx.disposeBag)

        output.imageUrl.drive(onNext: { [weak self] (url) in
            if let url = url {
                self?.ownerImageView.setSources(sources: [url])
                self?.ownerImageView.hero.id = url.absoluteString
            }
        }).disposed(by: rx.disposeBag)

        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: IssueCell.self)) { _, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)

        output.userSelected.drive(onNext: { user in
            viewModel.navigateTo(step: SearchStep.userDetails(user: user))
        }).disposed(by: rx.disposeBag)

        output.issueSelected.drive(onNext: { model in
            viewModel.navigateTo(step: SearchStep.issueDetails(value: model.repository, issue: model.issue))
        }).disposed(by: rx.disposeBag)
    }
}
