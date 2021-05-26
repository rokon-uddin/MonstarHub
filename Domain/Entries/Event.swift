//
//  Event.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


/// Event Types
///
/// - fork: Triggered when a user forks a repository.
/// - commitComment: Triggered when a commit comment is created.
/// - create: Represents a created repository, branch, or tag.
/// - issueComment: Triggered when an issue comment is created, edited, or deleted.
/// - issues: Triggered when an issue is assigned, unassigned, labeled, unlabeled, opened, edited, milestoned, demilestoned, closed, or reopened.
/// - member: Triggered when a user accepts an invitation or is removed as a collaborator to a repository, or has their permissions changed.
/// - organizationBlock: Triggered when an organization blocks or unblocks a user.
/// - `public`: Triggered when a private repository is open sourced. Without a doubt: the best GitHub event.
/// - release: Triggered when a release is published.
/// - star: The WatchEvent is related to starring a repository, not watching.
public enum EventType: String {
    case fork = "ForkEvent"
    case commitComment = "CommitCommentEvent"
    case create = "CreateEvent"
    case delete = "DeleteEvent"
    case issueComment = "IssueCommentEvent"
    case issues = "IssuesEvent"
    case member = "MemberEvent"
    case organizationBlock = "OrgBlockEvent"
    case `public` = "PublicEvent"
    case pullRequest = "PullRequestEvent"
    case pullRequestReviewComment = "PullRequestReviewCommentEvent"
    case push = "PushEvent"
    case release = "ReleaseEvent"
    case star = "WatchEvent"
    case unknown = ""
}

public struct Event {

    public var actor: User?
    public var createdAt: Date?
    public var id: String?
    public var organization: User?
    public var isPublic: Bool?
    public var repository: Repository?
    public var type: EventType = .unknown

    public var payload: Payload?


    public init(actor: User?,
                createdAt: Date?,
                id: String?,
                organization: User?,
                isPublic: Bool?,
                repository: Repository?,
                type: EventType) {

        self.actor = actor
        self.createdAt = createdAt
        self.id = id
        self.organization = organization
        self.isPublic = isPublic
        self.repository = repository
        self.type = type
    }
}

extension Event: Equatable {
    public static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}

public class Payload {

}

public class ForkPayload: Payload {

    public var repository: Repository?

    public init(repository: Repository?) {
        self.repository = repository
    }

}

public enum CreateEventType: String {
    case repository
    case branch
    case tag
}

public class CreatePayload: Payload {

    public var ref: String?
    public var refType: CreateEventType = .repository
    public var masterBranch: String?
    public var description: String?
    public var pusherType: String?

    public init(ref: String?, refType: CreateEventType,
                masterBranch: String?,
                description: String?, pusherType: String?) {
        self.ref = ref
        self.refType = refType
        self.masterBranch = masterBranch
        self.description = description
        self.pusherType = pusherType
    }
}

public enum DeleteEventType: String {
    case repository
    case branch
    case tag
}

public class DeletePayload: Payload {

    public var ref: String?
    public var refType: DeleteEventType = .repository
    public var pusherType: String?

    public init(ref: String?, refType: DeleteEventType, pusherType: String?) {
        self.ref = ref
        self.refType = refType
        self.pusherType = pusherType
    }
}

public class IssueCommentPayload: Payload {
    public var action: String?
    public var issue: Issue?
    public var comment: Comment?

    public init(action: String?,
                issue: Issue?,
                comment: Comment?) {
        self.action = action
        self.issue = issue
        self.comment = comment
    }
}

public class IssuesPayload: Payload {

    public var action: String?
    public var issue: Issue?
    public var repository: Repository?

    public init(action: String?,
                issue: Issue?,
                repository: Repository?) {
        self.action = action
        self.issue = issue
        self.repository = repository
    }
}

public class MemberPayload: Payload {

    public var action: String?
    public var member: User?

    public init(action: String?,
                member: User?) {
        self.action = action
        self.member = member
    }

}

public class PullRequestPayload: Payload {

    public var action: String?
    public var number: Int?
    public var pullRequest: PullRequest?

    public init(action: String?,
                number: Int?,
                pullRequest: PullRequest?) {

        self.action = action
        self.number = number
        self.pullRequest = pullRequest
    }
}

public class PullRequestReviewCommentPayload: Payload {

    public var action: String?
    public var comment: Comment?
    public var pullRequest: PullRequest?

    public init(action: String?,
                comment: Comment?,
                pullRequest: PullRequest?) {
        self.action = action
        self.comment = comment
        self.pullRequest = pullRequest
    }
}

public class PushPayload: Payload {
    public var ref: String?
    public var size: Int?
    public var commits: [Commit] = []

    public init(ref: String?, size: Int?, commits: [Commit] = []) {
        self.ref = ref
        self.size = size
        self.commits = commits
    }
}

public class ReleasePayload: Payload {

    public var action: String?
    public var release: Release?

    public init(action: String?,
                release: Release?) {
        self.action = action
        self.release = release
    }
}

public class StarPayload: Payload {

    public var action: String?

    public init(action: String?) {
        self.action = action
    }
}
