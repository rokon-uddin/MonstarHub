//
//  License.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Domain
import Foundation
import ObjectMapper

struct License: Mappable {

    var key: String?
    var name: String?
    var nodeId: String?
    var spdxId: AnyObject?
    var url: AnyObject?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        key <- map["key"]
        name <- map["name"]
        nodeId <- map["node_id"]
        spdxId <- map["spdx_id"]
        url <- map["url"]
    }
}

extension License: DomainConvertibleType {
    var asDomain: Domain.License {
        return Domain.License(key: key,
                              name: name,
                              nodeId: nodeId,
                              spdxId: spdxId,
                              url: url)
    }
}
