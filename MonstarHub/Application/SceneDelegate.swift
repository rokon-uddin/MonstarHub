//
//  SceneDelegate.swift
//  MonstarHub
//
//  Created by Rokon on 5/4/20.
//  Copyright © 2020 Monstarlab. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa
import Toast_Swift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    internal var window: UIWindow?
    private let disposeBag = DisposeBag()
    private var flowCoordinator: FlowCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        instantiateApplicationUserInterface(scene: scene)
        if Constants.Network.useStaging == true {
            // Logout
            AuthManager.removeToken()

            var theme = ThemeType.currentTheme()
            if theme.isDark != true {
                theme = theme.toggled()
            }
            theme = theme.withColor(color: .green)
            themeService.switch(theme)
        } else {
            connectedToInternet().skip(1).subscribe(onNext: { [weak self] (connected) in
                var style = ToastManager.shared.style
                style.backgroundColor = connected ? UIColor.Material.green: UIColor.Material.red
                let message = connected ? R.string.localizable.toastConnectionBackMessage.key.localized(): R.string.localizable.toastConnectionLostMessage.key.localized()
                let image = connected ? R.image.icon_toast_success(): R.image.icon_toast_warning()
                if let view = self?.window?.rootViewController?.view {
                    view.makeToast(message, position: .bottom, image: image, style: style)
                }
            }).disposed(by: rx.disposeBag)
        }

    }

    private func instantiateApplicationUserInterface(scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        guard let _window = window else { return }
        _window.windowScene = windowScene
        let rootFlow = RootFlow(rootWindow: _window)
        flowCoordinator = FlowCoordinator()
        flowCoordinator.coordinate(
            flow: rootFlow,
            with: RootStepper()
        )
    }
}
