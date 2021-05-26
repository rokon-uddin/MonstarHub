//
//  Branch.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Domain
import Foundation
import ObjectMapper

struct Branch: Mappable {

//    var links: Link?
    var commit: Commit?
    var name: String?
    var protectedField: Bool?
    var protectionUrl: String?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
//        links <- map["_links"]
        commit <- map["commit"]
        name <- map["name"]
        protectedField <- map["protected"]
        protectionUrl <- map["protection_url"]
    }
}

extension Branch: DomainConvertibleType {
    var asDomain: Domain.Branch {
        return Domain.Branch(commit: commit?.asDomain,
                             name: name,
                             protectedField: protectedField,
                             protectionUrl: protectionUrl)
    }
}
