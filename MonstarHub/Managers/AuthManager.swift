//
//  AuthManager.swift
//  MonstarHub
//
//  Created by Rokon on 1/4/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import KeychainAccess
import ObjectMapper
import RxSwift
import RxCocoa
import Domain

let loggedIn = BehaviorRelay<Bool>(value: false)

class AuthManager {

    /// The default singleton instance.
    static let shared = AuthManager()

    // MARK: - Properties
    fileprivate let tokenKey = "TokenKey"
    fileprivate let keychain = Keychain(service: Constants.App.bundleIdentifier)

    let tokenChanged = PublishSubject<Token?>()

    init() {
        loggedIn.accept(hasValidToken)
    }

    // TODO: Fix it
    var token: Token? {
//        get {
//            guard let jsonString = keychain[tokenKey] else { return nil }
//            return Mapper<Token>().map(JSONString: jsonString)
//        }
//        set {
//            if let token = newValue, let jsonString = token.toJSONString() {
//                keychain[tokenKey] = jsonString
//            } else {
//                keychain[tokenKey] = nil
//            }
//            tokenChanged.onNext(newValue)
//            loggedIn.accept(hasValidToken)
//        }
        return nil
    }

    var hasValidToken: Bool {
        return token?.isValid == true
    }

    // TODO: Fix it

    class func setToken(token: Token) {
//        AuthManager.shared.token = token
    }

    class func removeToken() {
//        AuthManager.shared.token = nil
    }

    class func tokenValidated() {
//        AuthManager.shared.token?.isValid = true
    }
}
