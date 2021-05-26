//
//  Comment.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

public struct Comment {

    public var authorAssociation: String?
    public var body: String?
    public var createdAt: Date?
    public var htmlUrl: String?
    public var id: Int?
    public var issueUrl: String?
    public var nodeId: String?
    public var updatedAt: Date?
    public var url: String?
    public var user: User?

    public init(authorAssociation: String?,
                body: String?,
                createdAt: Date?,
                htmlUrl: String?,
                id: Int?,
                issueUrl: String?,
                nodeId: String?,
                updatedAt: Date?,
                url: String?,
                user: User?) {
        self.authorAssociation = authorAssociation
        self.body = body
        self.createdAt = createdAt
        self.htmlUrl = htmlUrl
        self.id = id
        self.issueUrl = issueUrl
        self.nodeId = nodeId
        self.updatedAt = updatedAt
        self.url = url
        self.user = user
    }

}
