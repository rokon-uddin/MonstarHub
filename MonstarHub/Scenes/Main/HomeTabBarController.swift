//
//  HomeTabBarController.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController
import Localize_Swift
import RxSwift

enum HomeTabBarItem: Int {
    case search, news, notifications, settings, login

    var image: UIImage? {
        switch self {
        case .search: return R.image.icon_tabbar_search()
        case .news: return R.image.icon_tabbar_news()
        case .notifications: return R.image.icon_tabbar_activity()
        case .settings: return R.image.icon_tabbar_settings()
        case .login: return R.image.icon_tabbar_login()
        }
    }

    var title: String {
        switch self {
        case .search: return R.string.localizable.homeTabBarSearchTitle.key.localized()
        case .news: return R.string.localizable.homeTabBarEventsTitle.key.localized()
        case .notifications: return R.string.localizable.homeTabBarNotificationsTitle.key.localized()
        case .settings: return R.string.localizable.homeTabBarSettingsTitle.key.localized()
        case .login: return R.string.localizable.homeTabBarLoginTitle.key.localized()
        }
    }

    var animation: RAMItemAnimation {
        var animation: RAMItemAnimation
        switch self {
        case .search: animation = RAMFlipLeftTransitionItemAnimations()
        case .news: animation = RAMBounceAnimation()
        case .notifications: animation = RAMBounceAnimation()
        case .settings: animation = RAMRightRotationAnimation()
        case .login: animation = RAMBounceAnimation()
        }
        _ = themeService.rx
            .bind({ $0.secondary }, to: animation.rx.iconSelectedColor)
            .bind({ $0.secondary }, to: animation.rx.textSelectedColor)
        return animation
    }

    func getTabBarItem() -> RAMAnimatedTabBarItem {
        let item = RAMAnimatedTabBarItem(title: title, image: image, tag: rawValue)
        item.animation = animation
        _ = themeService.rx
            .bind({ $0.text }, to: item.rx.iconColor)
            .bind({ $0.text }, to: item.rx.textColor)
        return item
    }
}

class HomeTabBarController: RAMAnimatedTabBarController {

    var viewModel: HomeTabBarViewModel?

    init(viewModel: ViewModel?) {
        self.viewModel = viewModel as? HomeTabBarViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeUI()
        bindViewModel()
    }

    func makeUI() {
        NotificationCenter.default
            .rx.notification(NSNotification.Name(LCLLanguageChangeNotification))
            .subscribe { [weak self] (_) in
                self?.animatedItems.forEach({ (item) in
                    item.title = HomeTabBarItem(rawValue: item.tag)?.title
                })
                self?.setViewControllers(self?.viewControllers, animated: false)
                self?.setSelectIndex(from: 0, to: self?.selectedIndex ?? 0)
            }.disposed(by: rx.disposeBag)

        themeService.rx
            .bind({ $0.primaryDark }, to: tabBar.rx.barTintColor)
            .disposed(by: rx.disposeBag)

        themeService.typeStream.delay(DispatchTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] theme in
                switch theme {
                case .light(let color), .dark(let color):
                    guard let _ = self?.tabBar.items else { return }
                    self?.changeSelectedColor(color.color, iconSelectedColor: color.color)
                }
            }).disposed(by: rx.disposeBag)
    }

    func bindViewModel() {
        guard let viewModel = viewModel else { return }

        let input = HomeTabBarViewModel.Input(whatsNewTrigger: rx.viewDidAppear.mapToVoid())
        let output = viewModel.transform(input: input)

        // TODO: Fix it
        output.openWhatsNew.drive(onNext: { [weak self] (_) in
            if Constants.Network.useStaging == false {
                //                self?.navigator.show(segue: .whatsNew(block: block), sender: self, transition: .modal)
            }
        }).disposed(by: rx.disposeBag)
    }
}
