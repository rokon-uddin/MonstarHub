//
//  ErrorResponse.swift
//  NetworkPlatform
//
//  Created by Rokon on 1/6/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya
import Domain

public struct ErrorResponse: Mappable {
    var message: String?
    var errors: [ErrorModel] = []
    var documentationUrl: String?

    public init?(map: Map) {}
    init() {}

    public mutating func mapping(map: Map) {
        message <- map["message"]
        errors <- map["errors"]
        documentationUrl <- map["documentation_url"]
    }

    func detail() -> String {
        return errors.map { $0.message ?? "" }
            .joined(separator: "\n")
    }
}

extension ErrorResponse {
    var asErrorModel: Domain.ErrorModel {
        return Domain.ErrorModel(title: self.message,
                                 code: nil,
                                 description: self.detail())
    }
}

struct ErrorModel: Mappable {
    var code: String?
    var message: String?
    var field: String?
    var resource: String?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        field <- map["field"]
        resource <- map["resource"]
    }
}

extension Error {
    public var asAppError: AppError? {
        let errorResponse = self as? MoyaError
        do {
            if let body = try errorResponse?.response?.mapJSON() as? [String: Any],
                let errorResponse = Mapper<ErrorResponse>().map(JSON: body) {
                return AppError.serverError(model: errorResponse.asErrorModel)
            } else if let response = errorResponse?.response, let body = try response.mapJSON() as? [String] {
                let code = response.statusCode
                let model = Domain.ErrorModel(title: body.first, code: code, description: response.description)
                      return AppError.serverError(model: model)
            }
        } catch {
            print(error)
        }
        return AppError.serverError(model: Domain.ErrorModel(title: errorResponse?.response?.description, code: errorResponse?.response?.statusCode, description: errorResponse?.response?.description))
    }
}
