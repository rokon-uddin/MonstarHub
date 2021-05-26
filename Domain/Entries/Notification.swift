//
//  Notification.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

public struct Notification {

    public var id: String?
    public var lastReadAt: Date?
    public var reason: String?
    public var repository: Repository?
    public var subject: Subject?
    public var subscriptionUrl: String?
    public var unread: Bool?
    public var updatedAt: Date?
    public var url: String?

    public init(id: String?,
                lastReadAt: Date?,
                reason: String?,
                repository: Repository?,
                subject: Subject?,
                subscriptionUrl: String?,
                unread: Bool?,
                updatedAt: Date?,
                url: String?) {

        self.id = id
        self.lastReadAt = lastReadAt
        self.reason = reason
        self.repository = repository
        self.subject = subject
        self.subscriptionUrl = subscriptionUrl
        self.unread = unread
        self.updatedAt = updatedAt
        self.url = url

    }
}

extension Notification: Equatable {
    public static func == (lhs: Notification, rhs: Notification) -> Bool {
        return lhs.id == rhs.id
    }
}

public struct Subject {

    public var latestCommentUrl: String?
    public var title: String?
    public var type: String?
    public var url: String?

    public init(latestCommentUrl: String?,
                title: String?,
                type: String?,
                url: String?) {
        self.latestCommentUrl = latestCommentUrl
        self.title = title
        self.type = type
        self.url = url
    }
}
