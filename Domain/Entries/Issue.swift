//
//  Issue.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

public struct Issue {

    public var activeLockReason: String?
    public var assignee: User?
    public var assignees: [User]?
    public var body: String?
    public var closedAt: Date?
    public var closedBy: User?
    public var comments: Int?
    public var commentsUrl: String?
    public var createdAt: Date?
    public var eventsUrl: String?
    public var htmlUrl: String?
    public var id: Int?
    public var labels: [IssueLabel]?
    public var labelsUrl: String?
    public var locked: Bool?
    public var milestone: Milestone?
    public var nodeId: String?
    public var number: Int?
    public var pullRequest: PullRequest?
    public var repositoryUrl: String?
    public var state: State = .open
    public var title: String?
    public var updatedAt: Date?
    public var url: String?
    public var user: User?

    public init(activeLockReason: String?,
                assignee: User?,
                assignees: [User]?,
                body: String?,
                closedAt: Date?,
                closedBy: User?,
                comments: Int?,
                commentsUrl: String?,
                createdAt: Date?,
                eventsUrl: String?,
                htmlUrl: String?,
                id: Int?,
                labels: [IssueLabel]?,
                labelsUrl: String?,
                locked: Bool?,
                milestone: Milestone?,
                nodeId: String?,
                number: Int?,
                pullRequest: PullRequest?,
                repositoryUrl: String?,
                state: State = .open,
                title: String?,
                updatedAt: Date?,
                url: String?,
                user: User?) {

        self.activeLockReason = activeLockReason
        self.assignee = assignee
        self.assignees = assignees
        self.body = body
        self.closedAt = closedAt
        self.closedBy = closedBy
        self.comments = comments
        self.comments = comments
        self.createdAt = createdAt
        self.eventsUrl = eventsUrl
        self.htmlUrl = htmlUrl
        self.id = id
        self.labels = labels
        self.labels = labels
        self.locked = locked
        self.milestone = milestone
        self.nodeId = nodeId
        self.number = number
        self.pullRequest = pullRequest
        self.repositoryUrl = repositoryUrl
        self.state = state
        self.title = title
        self.updatedAt = updatedAt
        self.url = url
        self.user = user
    }

}

public struct IssueLabel {

    public var color: String?
    public var defaultField: Bool?
    public var descriptionField: String?
    public var id: Int?
    public var name: String?
    public var nodeId: String?
    public var url: String?

    public init (color: String?,
                 defaultField: Bool?,
                 descriptionField: String?,
                 id: Int?,
                 name: String?,
                 nodeId: String?,
                 url: String?) {

        self.color = color
        self.defaultField = defaultField
        self.descriptionField = descriptionField
        self.id = id
        self.name = name
        self.nodeId = nodeId
        self.url = url
    }
}
