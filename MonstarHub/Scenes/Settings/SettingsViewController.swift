//
//  SettingsViewController.swift
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

private let switchReuseIdentifier = R.reuseIdentifier.settingSwitchCell.identifier
private let reuseIdentifier = R.reuseIdentifier.settingCell.identifier
private let profileReuseIdentifier = R.reuseIdentifier.userCell.identifier
private let repositoryReuseIdentifier = R.reuseIdentifier.repositoryCell.identifier

class SettingsViewController: TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.navigationTitle = R.string.localizable.settingsNavigationTitle.key.localized()
        }).disposed(by: rx.disposeBag)

        tableView.register(R.nib.settingCell)
        tableView.register(R.nib.settingSwitchCell)
        tableView.register(R.nib.userCell)
        tableView.register(R.nib.repositoryCell)
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? SettingsViewModel else { return }

        let refresh = Observable.of(rx.viewWillAppear.mapToVoid(), languageChanged.asObservable()).merge()
        let input = SettingsViewModel.Input(trigger: refresh,
                                            selection: tableView.rx.modelSelected(SettingsSectionItem.self).asDriver())
        let output = viewModel.transform(input: input)

        let dataSource = RxTableViewSectionedReloadDataSource<SettingsSection>(configureCell: { _, tableView, indexPath, item in
            switch item {
            case .profileItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: profileReuseIdentifier, for: indexPath) as? UserCell)!
                cell.bind(to: viewModel)
                return cell
            case .bannerItem(let viewModel),
                 .nightModeItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: switchReuseIdentifier, for: indexPath) as? SettingSwitchCell)!
                cell.bind(to: viewModel)
                return cell
            case .themeItem(let viewModel),
                 .languageItem(let viewModel),
                 .contactsItem(let viewModel),
                 .removeCacheItem(let viewModel),
                 .acknowledgementsItem(let viewModel),
                 .whatsNewItem(let viewModel),
                 .logoutItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SettingCell)!
                cell.bind(to: viewModel)
                return cell
            case .repositoryItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: repositoryReuseIdentifier, for: indexPath) as? RepositoryCell)!
                cell.bind(to: viewModel)
                return cell
            }
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })

        output.items.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        output.selectedEvent.drive(onNext: { [weak self] (item) in
            switch item {
            case .profileItem, .themeItem, .languageItem, .contactsItem, .repositoryItem:
                if let step = viewModel.stepFor(item) {
                    viewModel.navigateTo(step: step)
                }
            case .logoutItem:
                self?.deselectSelectedRow()
                self?.logoutAction()
            case .bannerItem,
                 .nightModeItem:
                self?.deselectSelectedRow()

            case .removeCacheItem:
                self?.deselectSelectedRow()
            case .acknowledgementsItem:
                viewModel.navigateTo(step: SettingsStep.acknowledgementsItem)
            case .whatsNewItem:
                viewModel.navigateTo(step: SettingsStep.whatsNewItem(block: viewModel.whatsNewBlock()))
                analytics.log(.whatsNew)
            }
        }).disposed(by: rx.disposeBag)
    }

    func logoutAction() {
        var name = ""
        if let user = User.currentUser() {
            name = user.name ?? user.login ?? ""
        }

        let alertController = UIAlertController(title: name,
                                                message: R.string.localizable.settingsLogoutAlertMessage.key.localized(),
                                                preferredStyle: UIAlertController.Style.alert)
        let logoutAction = UIAlertAction(title: R.string.localizable.settingsLogoutAlertConfirmButtonTitle.key.localized(),
                                         style: .destructive) { [weak self] (_: UIAlertAction) in
            self?.logout()
        }

        let cancelAction = UIAlertAction(title: R.string.localizable.commonCancel.key.localized(),
                                         style: .default) { (_: UIAlertAction) in
        }

        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func logout() {
        User.removeCurrentUser()
        AuthManager.removeToken()
        // TODO: Fix it
        //        Application.shared.presentInitialScreen(in: Application.shared.window)

        analytics.log(.logout)
        analytics.reset()
    }
}
