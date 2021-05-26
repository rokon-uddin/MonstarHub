//
//  SettingsViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import Domain

class SettingsViewModel: ViewModel, InputOutType {

    struct Input {
        let trigger: Observable<Void>
        let selection: Driver<SettingsSectionItem>
    }

    struct Output {
        let items: BehaviorRelay<[SettingsSection]>
        let selectedEvent: Driver<SettingsSectionItem>
    }

    let currentUser: User?

    let bannerEnabled: BehaviorRelay<Bool>
    let nightModeEnabled: BehaviorRelay<Bool>

    let whatsNewManager: WhatsNewManager

    let MonstarHubRepository = BehaviorRelay<Repository?>(value: nil)

    var cellDisposeBag = DisposeBag()
    typealias Services = AppServices
    private let services: Services

    init(services: Services) {
        self.services = services
        currentUser = User.currentUser()
        whatsNewManager = WhatsNewManager.shared
        bannerEnabled = BehaviorRelay(value: LibsManager.shared.bannersEnabled.value)
        nightModeEnabled = BehaviorRelay(value: ThemeType.currentTheme().isDark)
        super.init()
        bannerEnabled.bind(to: LibsManager.shared.bannersEnabled).disposed(by: rx.disposeBag)
    }

    func transform(input: Input) -> Output {

        let elements = BehaviorRelay<[SettingsSection]>(value: [])
        let removeCache = PublishSubject<Void>()

        let cacheRemoved = removeCache.flatMapLatest { () -> Observable<Void> in
            return LibsManager.shared.removeKingfisherCache()
        }

        let refresh = Observable.of(input.trigger, cacheRemoved, MonstarHubRepository.mapToVoid(),
                                    bannerEnabled.mapToVoid(), nightModeEnabled.mapToVoid()).merge()

        let cacheSize = refresh.flatMapLatest { () -> Observable<Int> in
            return LibsManager.shared.kingfisherCacheSize()
        }

        Observable.combineLatest(refresh, cacheSize).map { [weak self] (_, size) -> [SettingsSection] in
            guard let self = self else { return [] }
            self.cellDisposeBag = DisposeBag()
            var items: [SettingsSection] = []

            if loggedIn.value {
                var accountItems: [SettingsSectionItem] = []
                if let user = self.currentUser {
                    let profileCellViewModel = UserCellViewModel(with: user)
                    accountItems.append(SettingsSectionItem.profileItem(viewModel: profileCellViewModel))
                }

                let logoutCellViewModel = SettingCellViewModel(with: R.string.localizable.settingsLogOutTitle.key.localized(), detail: nil,
                                                               image: R.image.icon_cell_logout()?.template, hidesDisclosure: true)
                accountItems.append(SettingsSectionItem.logoutItem(viewModel: logoutCellViewModel))

                items.append(SettingsSection.setting(title: R.string.localizable.settingsAccountSectionTitle.key.localized(), items: accountItems))
            }

            if let MonstarHubRepository = self.MonstarHubRepository.value {
                let MonstarHubCellViewModel = RepositoryCellViewModel(with: MonstarHubRepository)
                items.append(SettingsSection.setting(title: R.string.localizable.settingsProjectsSectionTitle.key.localized(), items: [
                    SettingsSectionItem.repositoryItem(viewModel: MonstarHubCellViewModel)
                ]))
            }

            let bannerEnabled = self.bannerEnabled.value
            let bannerImage = bannerEnabled ? R.image.icon_cell_smile()?.template : R.image.icon_cell_frown()?.template
            let bannerCellViewModel = SettingSwitchCellViewModel(with: R.string.localizable.settingsBannerTitle.key.localized(), detail: nil,
                                                                 image: bannerImage, hidesDisclosure: true, isEnabled: bannerEnabled)
            bannerCellViewModel.switchChanged.skip(1).bind(to: self.bannerEnabled).disposed(by: self.cellDisposeBag)

            let nightModeEnabled = self.nightModeEnabled.value
            let nightModeCellViewModel = SettingSwitchCellViewModel(with: R.string.localizable.settingsNightModeTitle.key.localized(), detail: nil,
                                                                    image: R.image.icon_cell_night_mode()?.template, hidesDisclosure: true, isEnabled: nightModeEnabled)
            nightModeCellViewModel.switchChanged.skip(1).bind(to: self.nightModeEnabled).disposed(by: self.cellDisposeBag)

            let themeCellViewModel = SettingCellViewModel(with: R.string.localizable.settingsThemeTitle.key.localized(), detail: nil,
                                                          image: R.image.icon_cell_theme()?.template, hidesDisclosure: false)

            let languageCellViewModel = SettingCellViewModel(with: R.string.localizable.settingsLanguageTitle.key.localized(), detail: nil,
                                                             image: R.image.icon_cell_language()?.template, hidesDisclosure: false)

            let contactsCellViewModel = SettingCellViewModel(with: R.string.localizable.settingsContactsTitle.key.localized(), detail: nil,
                                                             image: R.image.icon_cell_company()?.template, hidesDisclosure: false)

            let removeCacheCellViewModel = SettingCellViewModel(with: R.string.localizable.settingsRemoveCacheTitle.key.localized(), detail: size.sizeFromByte(),
                                                                image: R.image.icon_cell_remove()?.template, hidesDisclosure: true)

            let acknowledgementsCellViewModel = SettingCellViewModel(with: R.string.localizable.settingsAcknowledgementsTitle.key.localized(), detail: nil,
                                                                     image: R.image.icon_cell_acknowledgements()?.template, hidesDisclosure: false)

            let whatsNewCellViewModel = SettingCellViewModel(with: R.string.localizable.settingsWhatsNewTitle.key.localized(), detail: nil,
                                                             image: R.image.icon_cell_whats_new()?.template, hidesDisclosure: false)

            items += [
                SettingsSection.setting(title: R.string.localizable.settingsPreferencesSectionTitle.key.localized(), items: [
                    SettingsSectionItem.bannerItem(viewModel: bannerCellViewModel),
                    SettingsSectionItem.nightModeItem(viewModel: nightModeCellViewModel),
                    SettingsSectionItem.themeItem(viewModel: themeCellViewModel),
                    SettingsSectionItem.languageItem(viewModel: languageCellViewModel),
                    SettingsSectionItem.contactsItem(viewModel: contactsCellViewModel),
                    SettingsSectionItem.removeCacheItem(viewModel: removeCacheCellViewModel)
                ]),
                SettingsSection.setting(title: R.string.localizable.settingsSupportSectionTitle.key.localized(), items: [
                    SettingsSectionItem.acknowledgementsItem(viewModel: acknowledgementsCellViewModel),
                    SettingsSectionItem.whatsNewItem(viewModel: whatsNewCellViewModel)
                ])
            ]

            return items
        }.bind(to: elements).disposed(by: rx.disposeBag)

        input.trigger.flatMapLatest { [weak self] () -> Observable<Repository> in
            guard let self = self else { return Observable.just(Repository()) }
            let fullname = "rokon-mlbd/MonstarHub"
            let qualifiedName = "main"
            return self.services.gitHubUseCase
                .repository(fullname: fullname, qualifiedName: qualifiedName)
                .trackActivity(self.loading)
                .trackError(self.error)
            }.subscribe(onNext: { [weak self] (repository) in
                self?.MonstarHubRepository.accept(repository)
            }).disposed(by: rx.disposeBag)

        let selectedEvent = input.selection

        selectedEvent.asObservable().subscribe(onNext: { (item) in
            switch item {
            case .removeCacheItem: removeCache.onNext(())
            default: break
            }
        }).disposed(by: rx.disposeBag)

        nightModeEnabled.subscribe(onNext: { (isEnabled) in
            var theme = ThemeType.currentTheme()
            if theme.isDark != isEnabled {
                theme = theme.toggled()
            }
            themeService.switch(theme)
        }).disposed(by: rx.disposeBag)

        nightModeEnabled.skip(1).subscribe(onNext: { (isEnabled) in
            analytics.log(.appNightMode(enabled: isEnabled))
            analytics.set(.nightMode(value: isEnabled))
        }).disposed(by: rx.disposeBag)

        bannerEnabled.skip(1).subscribe(onNext: { (isEnabled) in
            analytics.log(.appAds(enabled: isEnabled))
        }).disposed(by: rx.disposeBag)

        cacheRemoved.subscribe(onNext: { () in
            analytics.log(.appCacheRemoved)
        }).disposed(by: rx.disposeBag)

        return Output(items: elements,
                      selectedEvent: selectedEvent)
    }

    func stepFor(_ item: SettingsSectionItem) -> SettingsStep? {
        switch item {
        case .profileItem:
            let user = currentUser ?? User()
            return .userDetails(user: user)
        case .themeItem:
            return .theme
        case .languageItem:
            return .language
        case .contactsItem:
            return .contacts
        case .repositoryItem(let viewModel):
            let repo = viewModel.repository
            return .repositoryDetails(value: repo)
        default:
            return nil
        }
    }

    func whatsNewBlock() -> WhatsNewBlock {
        return whatsNewManager.whatsNew(trackVersion: false)
    }
}
