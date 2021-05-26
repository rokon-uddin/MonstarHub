//
//  RepositoryViewController.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import BonMot
import FloatingPanel

private let reuseIdentifier = R.reuseIdentifier.repositoryDetailCell.identifier
private let languagesReuseIdentifier = R.reuseIdentifier.languagesCell.identifier

class RepositoryViewController: TableViewController {

    lazy var rightBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_github(), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var ownerImageView: SlideImageView = {
        let view = SlideImageView()
        view.cornerRadius = 50
        return view
    }()

    lazy var starButton: Button = {
        let view = Button()
        view.borderColor = .white
        view.borderWidth = Constants.Dimensions.borderWidth
        view.tintColor = .white
        view.cornerRadius = 20
        view.hero.id = "ActionButtonId"
        return view
    }()

    lazy var detailLabel: Label = {
        var view = Label()
        view.numberOfLines = 0
        return view
    }()

    lazy var headerStackView: StackView = {
        let headerView = View()
        headerView.addSubview(self.ownerImageView)
        self.ownerImageView.snp.makeConstraints({ (make) in
            make.top.left.centerX.centerY.equalToSuperview()
            make.size.equalTo(100)
        })
        headerView.addSubview(self.starButton)
        self.starButton.snp.remakeConstraints({ (make) in
            make.bottom.equalTo(self.ownerImageView)
            make.right.equalTo(self.ownerImageView)
            make.size.equalTo(40)
        })
        let subviews: [UIView] = [headerView, self.detailLabel]
        let view = StackView(arrangedSubviews: subviews)
        view.axis = .horizontal
        return view
    }()

    lazy var headerView: View = {
        let view = View()
        view.hero.id = "TopHeaderId"
        let subviews: [UIView] = [self.headerStackView, self.actionButtonsStackView]
        let stackView = StackView(arrangedSubviews: subviews)
        view.addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(self.inset)
        })
        return view
    }()

    lazy var watchersButton: Button = {
        let view = Button()
        return view
    }()

    lazy var starsButton: Button = {
        let view = Button()
        return view
    }()

    lazy var forksButton: Button = {
        let view = Button()
        return view
    }()

    lazy var actionButtonsStackView: StackView = {
        let subviews: [UIView] = [self.watchersButton, self.starsButton, self.forksButton]
        let view = StackView(arrangedSubviews: subviews)
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()

    var panelContent: WebViewController!
    let panel = FloatingPanelController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        themeService.rx
            .bind({ $0.primaryDark }, to: headerView.rx.backgroundColor)
            .bind({ $0.text }, to: detailLabel.rx.textColor)
            .disposed(by: rx.disposeBag)

        navigationItem.rightBarButtonItem = rightBarButton

        panelContent = WebViewController(viewModel: nil)
        panel.set(contentViewController: panelContent)
        panel.track(scrollView: panelContent.webView.scrollView)

        emptyDataSetTitle = ""
        emptyDataSetImage = nil
        stackView.insertArrangedSubview(headerView, at: 0)
        tableView.footRefreshControl = nil
        tableView.register(R.nib.repositoryDetailCell)
        tableView.register(R.nib.languagesCell)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
//        bannerView.isHidden = true
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? RepositoryViewModel else { return }

        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let input = RepositoryViewModel.Input(headerRefresh: refresh,
                                              imageSelection: ownerImageView.rx.tap(),
                                              openInWebSelection: rightBarButton.rx.tap.asObservable(),
                                              watchersSelection: watchersButton.rx.tap.asObservable(),
                                              starsSelection: starsButton.rx.tap.asObservable(),
                                              forksSelection: forksButton.rx.tap.asObservable(),
                                              selection: tableView.rx.modelSelected(RepositorySectionItem.self).asDriver(),
                                              starSelection: starButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)

        let dataSource = RxTableViewSectionedReloadDataSource<RepositorySection>(configureCell: { _, tableView, indexPath, item in
            switch item {
            case .parentItem(let viewModel),
                 .languageItem(let viewModel),
                 .sizeItem(let viewModel),
                 .createdItem(let viewModel),
                 .updatedItem(let viewModel),
                 .homepageItem(let viewModel),
                 .issuesItem(let viewModel),
                 .commitsItem(let viewModel),
                 .branchesItem(let viewModel),
                 .releasesItem(let viewModel),
                 .pullRequestsItem(let viewModel),
                 .eventsItem(let viewModel),
                 .notificationsItem(let viewModel),
                 .contributorsItem(let viewModel),
                 .sourceItem(let viewModel),
                 .starHistoryItem(let viewModel),
                 .countLinesOfCodeItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? RepositoryDetailCell)!
                cell.bind(to: viewModel)
                return cell
            case .languagesItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: languagesReuseIdentifier, for: indexPath) as? LanguagesCell)!
                cell.bind(to: viewModel)
                return cell
            }
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })

        output.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        output.selectedEvent.drive(onNext: { [weak self] (item) in
            switch item {
            case .parentItem, .issuesItem, .commitsItem, .branchesItem, .releasesItem, .pullRequestsItem, .eventsItem, .notificationsItem, .countLinesOfCodeItem:
                if let step = viewModel.stepFor(item) {
                    viewModel.navigateTo(step: step)
                }
            case .contributorsItem:
                if let step = viewModel.stepFor(item) {
                    viewModel.navigateTo(step: step)
                }

            case .homepageItem:
                if let url = viewModel.repository.value.homepage?.url {
                    viewModel.navigateTo(step: SearchStep.webController(url))
                }

            case .sourceItem:
                if let step = viewModel.stepFor(item) {
                    viewModel.navigateTo(step: step)
                }
            case .starHistoryItem:
                if let url = viewModel.starHistoryUrl() {
                    viewModel.navigateTo(step: SearchStep.webController(url))
                }
            default:
                self?.deselectSelectedRow()
            }
        }).disposed(by: rx.disposeBag)

        output.name.drive(onNext: { [weak self] (title) in
            self?.navigationTitle = title
        }).disposed(by: rx.disposeBag)

        output.description.drive(detailLabel.rx.text).disposed(by: rx.disposeBag)

        output.imageUrl.drive(onNext: { [weak self] (url) in
            if let url = url {
                self?.ownerImageView.setSources(sources: [url])
                self?.ownerImageView.hero.id = url.absoluteString
            }
        }).disposed(by: rx.disposeBag)

        output.hidesStarButton.drive(starButton.rx.isHidden).disposed(by: rx.disposeBag)

        output.starring.map { (starred) -> UIImage? in
            let image = starred ? R.image.icon_button_unstar() : R.image.icon_button_star()
            return image?.template
        }.drive(starButton.rx.image()).disposed(by: rx.disposeBag)

        output.watchersCount.drive(onNext: { [weak self] (count) in
            let text = R.string.localizable.repositoryWatchersButtonTitle.key.localized()
            self?.watchersButton.setAttributedTitle(self?.attributedText(title: text, value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.starsCount.drive(onNext: { [weak self] (count) in
            let text = R.string.localizable.repositoryStarsButtonTitle.key.localized()
            self?.starsButton.setAttributedTitle(self?.attributedText(title: text, value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.forksCount.drive(onNext: { [weak self] (count) in
            let text = R.string.localizable.repositoryForksButtonTitle.key.localized()
            self?.forksButton.setAttributedTitle(self?.attributedText(title: text, value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.imageSelected.drive(onNext: { user in
            viewModel.navigateTo(step: SearchStep.userDetails(user: user))
        }).disposed(by: rx.disposeBag)

        output.openInWebSelected.drive(onNext: { url in
            viewModel.navigateTo(step: SearchStep.webController(url))
        }).disposed(by: rx.disposeBag)

        output.repositoriesSelected.drive(onNext: { mode in
            viewModel.navigateTo(step: SearchStep.repositories(mode: mode))
        }).disposed(by: rx.disposeBag)

        output.usersSelected.drive(onNext: { mode in
            viewModel.navigateTo(step: SearchStep.users(mode: mode))
        }).disposed(by: rx.disposeBag)

        viewModel.readme.subscribe(onNext: { [weak self] (content) in
            guard let self = self else { return }
            if let url = content?.htmlUrl?.url {
                self.panelContent.load(url: url)
                self.panel.addPanel(toParent: self)
                self.panel.move(to: .tip, animated: true)
            } else {
                self.panel.removePanelFromParent(animated: false)
            }
        }).disposed(by: rx.disposeBag)
    }

    func attributedText(title: String, value: Int) -> NSAttributedString {
        let titleText = title.styled(with: .color(.white),
                                     .font(.boldSystemFont(ofSize: 12)),
                                     .alignment(.center))
        let valueText = value.string.styled(with: .color(.white),
                                            .font(.boldSystemFont(ofSize: 18)),
                                            .alignment(.center))
        return NSAttributedString.composed(of: [
            titleText, Special.nextLine,
            valueText
        ])
    }
}
