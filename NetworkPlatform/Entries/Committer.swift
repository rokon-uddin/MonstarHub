//
//  Committer.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Domain
import Foundation
import ObjectMapper

struct Committer: Mappable {

    var name: String?
    var email: String?
    var date: Date?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        date <- (map["date"], ISO8601DateTransform())
    }
}

extension Committer: DomainConvertibleType {
    var asDomain: Domain.Committer {
        return Domain.Committer(name: name,
                                email: email,
                                date: date)
    }
}
