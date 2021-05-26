//
//  LoginViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt
import SafariServices
import Domain

private let loginURL = URL(string: "http://github.com/login/oauth/authorize?client_id=\(Constants.Keys.github.appId)&scope=\(Constants.App.githubScope)")!
private let callbackURLScheme = "MonstarHub"

class LoginViewModel: ViewModel, InputOutType {

    struct Input {
        let segmentSelection: Driver<LoginSegments>
        let basicLoginTrigger: Driver<Void>
        let personalLoginTrigger: Driver<Void>
        let oAuthLoginTrigger: Driver<Void>
    }

    struct Output {
        let basicLoginButtonEnabled: Driver<Bool>
        let personalLoginButtonEnabled: Driver<Bool>
        let hidesBasicLoginView: Driver<Bool>
        let hidesPersonalLoginView: Driver<Bool>
        let hidesOAuthLoginView: Driver<Bool>
    }

    let login = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")

    let personalToken = BehaviorRelay(value: "")

    let code = PublishSubject<String>()

    var tokenSaved = PublishSubject<Void>()

    private var _authSession: Any?
    typealias Services = AppServices
    private let services: Services

    init(services: Services) {
        self.services = services
        super.init()
    }

    private var authSession: SFAuthenticationSession? {
        get {
            return _authSession as? SFAuthenticationSession
        }
        set {
            _authSession = newValue
        }
    }

    func transform(input: Input) -> Output {

        input.basicLoginTrigger.drive(onNext: { [weak self] () in
            if let login = self?.login.value,
                let password = self?.password.value,
                let authHash = "\(login):\(password)".base64Encoded {
                AuthManager.setToken(token: Token(basicToken: authHash))
                self?.tokenSaved.onNext(())
            }
        }).disposed(by: rx.disposeBag)

        input.personalLoginTrigger.drive(onNext: { [weak self] () in
            if let personalToken = self?.personalToken.value {
                AuthManager.setToken(token: Token(personalToken: personalToken))
                self?.tokenSaved.onNext(())
            }
        }).disposed(by: rx.disposeBag)

        input.oAuthLoginTrigger.drive(onNext: { [weak self] () in
            self?.authSession = SFAuthenticationSession(url: loginURL, callbackURLScheme: callbackURLScheme, completionHandler: { (callbackUrl, error) in
                if let error = error {
                    logError(error.localizedDescription)
                }
                if let codeValue = callbackUrl?.queryParameters?["code"] {
                    self?.code.onNext(codeValue)
                }
            })
            self?.authSession?.start()
        }).disposed(by: rx.disposeBag)

        // TODO: Fix the warning
        let tokenRequest = code.flatMapLatest { (code) -> Observable<RxSwift.Event<Domain.Token>> in
            let clientId = Constants.Keys.github.appId
            let clientSecret = Constants.Keys.github.apiKey

            let sdfasdf = self.services.gitHubUseCase
                .createAccessToken(clientId: clientId, clientSecret: clientSecret, code: code, redirectUri: nil, state: nil)
                .trackActivity(self.loading)
                .materialize() as! Observable<RxSwift.Event<Domain.Token>>

            return sdfasdf
        }.share()

        tokenRequest.elements().subscribe(onNext: { [weak self] (_) in
            // TODO: Fix it
//            AuthManager.setToken(token: token)
            self?.tokenSaved.onNext(())
        }).disposed(by: rx.disposeBag)

        let _error = tokenRequest.errors().compactMap { $0.asAppError }
        _error.bind(to: appError)
            .disposed(by: rx.disposeBag)

        let profileRequest = tokenSaved.flatMapLatest {
            return self.services.gitHubUseCase
                .profile()
                .trackActivity(self.loading)
                .materialize()
        }.share()

        profileRequest.elements().subscribe(onNext: { (user) in
            user.save()
            AuthManager.tokenValidated()

            // TODO: Fix it
//            if let login = user.login, let type = AuthManager.shared.token?.type().description {
//                analytics.log(.login(login: login, type: type))
//            }
            // TODO: Fix it
//            Application.shared.presentInitialScreen(in: Application.shared.window)
        }).disposed(by: rx.disposeBag)

        let profileError = profileRequest.errors().compactMap { $0.asAppError }
        profileError.bind(to: appError)
            .disposed(by: rx.disposeBag)
        appError.subscribe(onNext: { (_) in
            AuthManager.removeToken()
        }).disposed(by: rx.disposeBag)

        let basicLoginButtonEnabled = BehaviorRelay.combineLatest(login, password, self.loading.asObservable()) {
            return $0.isNotEmpty && $1.isNotEmpty && !$2
        }.asDriver(onErrorJustReturn: false)

        let personalLoginButtonEnabled = BehaviorRelay.combineLatest(personalToken, self.loading.asObservable()) {
            return $0.isNotEmpty && !$1
        }.asDriver(onErrorJustReturn: false)

        let hidesBasicLoginView = input.segmentSelection.map { $0 != LoginSegments.basic }
        let hidesPersonalLoginView = input.segmentSelection.map { $0 != LoginSegments.personal }
        let hidesOAuthLoginView = input.segmentSelection.map { $0 != LoginSegments.oAuth }

        return Output(basicLoginButtonEnabled: basicLoginButtonEnabled,
                      personalLoginButtonEnabled: personalLoginButtonEnabled,
                      hidesBasicLoginView: hidesBasicLoginView,
                      hidesPersonalLoginView: hidesPersonalLoginView,
                      hidesOAuthLoginView: hidesOAuthLoginView)
    }
}
