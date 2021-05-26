//
//  License.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


public struct License {

    public var key: String?
    public var name: String?
    public var nodeId: String?
    public var spdxId: AnyObject?
    public var url: AnyObject?


    public init(key: String?,
                name: String?,
                nodeId: String?,
                spdxId: AnyObject?,
                url: AnyObject?
    ) {

        self.key = key
        self.name = name
        self.nodeId = nodeId
        self.spdxId = spdxId
        self.url = url

    }
}
