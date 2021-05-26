//
//  Milestone.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

public struct Milestone {

    public var closedAt: Date?
    public var closedIssues: Int?
    public var createdAt: Date?
    public var creator: User?
    public var descriptionField: String?
    public var dueOn: Date?
    public var htmlUrl: String?
    public var id: Int?
    public var labelsUrl: String?
    public var nodeId: String?
    public var number: Int?
    public var openIssues: Int?
    public var state: State = .open
    public var title: String?
    public var updatedAt: Date?
    public var url: String?


    public init(closedAt: Date?,
                closedIssues: Int?,
                createdAt: Date?,
                creator: User?,
                descriptionField: String?,
                dueOn: Date?,
                htmlUrl: String?,
                id: Int?,
                labelsUrl: String?,
                nodeId: String?,
                number: Int?,
                openIssues: Int?,
                state: State = .open,
                title: String?,
                updatedAt: Date?,
                url: String?) {
        self.closedAt = closedAt
        self.closedIssues = closedIssues
        self.createdAt = createdAt
        self.creator = creator
        self.descriptionField = descriptionField
        self.dueOn = dueOn
        self.htmlUrl = htmlUrl
        self.id = id
        self.labelsUrl = labelsUrl
        self.nodeId = nodeId
        self.number = number
        self.openIssues = openIssues
        self.state = state
        self.title = title
        self.updatedAt = updatedAt
        self.url = url
    }
}
