//
//  AppError.swift
//  MonstarHub
//
//  Created by Rokon on 1/6/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation

public struct ErrorModel {
    public let title: String?
    public let code: Int?
    public let description: String?

    public init(title: String?,
                code: Int?,
                description: String?) {
        self.title = title
        self.code = code
        self.description = description
    }
}

public enum AppError: Error {
    case serverError(model: ErrorModel)
    case paramError

    public var title: String {
        switch self {
        case .serverError(let model): return model.title ?? ""
        default: return "Unknown Error"
        }
    }

    public var description: String {
        switch self {
        case .serverError(let model): return model.description ?? ""
        default: return "Unknown Error"
        }
    }

    public var code: Int? {
        switch self {
        case .serverError(let model): return model.code
        default: return nil
        }
    }
}
