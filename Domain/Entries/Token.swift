//
//  Token.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation

public enum TokenType {
    case basic(token: String)
    case personal(token: String)
    case oAuth(token: String)
    case unauthorized

    public var description: String {
        switch self {
        case .basic: return "basic"
        case .personal: return "personal"
        case .oAuth: return "OAuth"
        case .unauthorized: return "unauthorized"
        }
    }
}

public struct Token {

    public var isValid = false

    // Basic
    public var basicToken: String?

    // Personal Access Token
    public var personalToken: String?

    // OAuth2
    public var accessToken: String?
    public var tokenType: String?
    public var scope: String?

    public init(isValid: Bool,
         basicToken: String?,
         personalToken: String?,
         accessToken: String?,
         tokenType: String?,
         scope: String?) {

        self.isValid = isValid
        self.basicToken = basicToken
        self.personalToken = personalToken
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.scope = scope
    }

    public init(basicToken: String) {
        self.basicToken = basicToken
    }

    public init(personalToken: String) {
        self.personalToken = personalToken
    }


    public func type() -> TokenType {
        if let token = basicToken {
            return .basic(token: token)
        }
        if let token = personalToken {
            return .personal(token: token)
        }
        if let token = accessToken {
            return .oAuth(token: token)
        }
        return .unauthorized
    }
}
