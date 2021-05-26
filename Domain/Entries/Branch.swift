//
//  Branch.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

public struct Branch {
//    var links: Link?
    public var commit: Commit?
    public var name: String?
    public var protectedField: Bool?
    public var protectionUrl: String?

    public init(commit: Commit?,
                name: String?,
                protectedField: Bool?,
                protectionUrl: String?) {

        self.commit = commit
        self.name = name
        self.protectedField = protectedField
        self.protectionUrl = protectionUrl
    }
}
