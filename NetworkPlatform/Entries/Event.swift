//
//  Event.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Domain
import Foundation
import ObjectMapper

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
enum EventType: String {
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

/// Each event has a similar JSON schema, but a unique payload object that is determined by its event type.
struct Event: Mappable {

    var actor: User?
    var createdAt: Date?
    var id: String?
    var organization: User?
    var isPublic: Bool?
    var repository: Repository?
    var type: EventType = .unknown

    var payload: Payload?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        actor <- map["actor"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        id <- map["id"]
        organization <- map["org"]
        isPublic <- map["public"]
        repository <- map["repo"]
        type <- map["type"]

        payload = Mapper<Payload>().map(JSON: map.JSON)

        if let fullname = repository?.name {
            let parts = fullname.components(separatedBy: "/")
            repository?.name = parts.last
            repository?.owner = User()
            repository?.owner?.login = parts.first
            repository?.fullname = fullname
        }
    }
}

extension Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Event: DomainConvertibleType {
    var asDomain: Domain.Event {
        return Domain.Event(actor: actor?.asDomain,
                            createdAt: createdAt,
                            id: id,
                            organization: organization?.asDomain,
                            isPublic: isPublic,
                            repository: repository?.asDomain,
                            type: Domain.EventType(rawValue: type.rawValue)!)
    }
}

class Payload: StaticMappable {

    required init?(map: Map) {}
    init() {}

    func mapping(map: Map) {}

    static func objectForMapping(map: Map) -> BaseMappable? {
        var type: EventType = .unknown
        type <- map["type"]
        switch type {
        case .fork: return ForkPayload()
        case .create: return CreatePayload()
        case .delete: return DeletePayload()
        case .issueComment: return IssueCommentPayload()
        case .issues: return IssuesPayload()
        case .member: return MemberPayload()
        case .pullRequest: return PullRequestPayload()
        case .pullRequestReviewComment: return PullRequestReviewCommentPayload()
        case .push: return PushPayload()
        case .release: return ReleasePayload()
        case .star: return StarPayload()
        default: return Payload()
        }
    }
}


class ForkPayload: Payload {

    var repository: Repository?

    override func mapping(map: Map) {
        super.mapping(map: map)

        repository <- map["payload.forkee"]
    }
}

extension ForkPayload: DomainConvertibleType {
    var asDomain: Domain.ForkPayload {
        return Domain.ForkPayload(repository: repository?.asDomain)
    }
}

enum CreateEventType: String {
    case repository
    case branch
    case tag
}

class CreatePayload: Payload {

    var ref: String?
    var refType: CreateEventType = .repository
    var masterBranch: String?
    var description: String?
    var pusherType: String?

    override func mapping(map: Map) {
        super.mapping(map: map)

        ref <- map["payload.ref"]
        refType <- map["payload.ref_type"]
        masterBranch <- map["payload.master_branch"]
        description <- map["payload.description"]
        pusherType <- map["payload.pusher_type"]
    }
}

extension CreatePayload: DomainConvertibleType {
    var asDomain: Domain.CreatePayload {
        return Domain.CreatePayload(ref: ref,
                                    refType: Domain.CreateEventType(rawValue: refType.rawValue)!,
                                    masterBranch: masterBranch,
                                    description: description,
                                    pusherType: pusherType)
    }
}

enum DeleteEventType: String {
    case repository
    case branch
    case tag
}

class DeletePayload: Payload {

    var ref: String?
    var refType: DeleteEventType = .repository
    var pusherType: String?

    override func mapping(map: Map) {
        super.mapping(map: map)

        ref <- map["payload.ref"]
        refType <- map["payload.ref_type"]
        pusherType <- map["payload.pusher_type"]
    }
}

extension DeletePayload: DomainConvertibleType {
    var asDomain: Domain.DeletePayload{
        return Domain.DeletePayload(ref: ref,
                                    refType: Domain.DeleteEventType(rawValue: refType.rawValue)!,
                                    pusherType: pusherType)
    }
}

class IssueCommentPayload: Payload {

    var action: String?
    var issue: Issue?
    var comment: Comment?

    override func mapping(map: Map) {
        super.mapping(map: map)

        action <- map["payload.action"]
        issue <- map["payload.issue"]
        comment <- map["payload.comment"]
    }
}

extension IssueCommentPayload: DomainConvertibleType {
    var asDomain: Domain.IssueCommentPayload {
        return Domain.IssueCommentPayload(action: action,
                                    issue: issue?.asDomain,
                                    comment: comment?.asDomain)
    }
}

class IssuesPayload: Payload {

    var action: String?
    var issue: Issue?
    var repository: Repository?

    override func mapping(map: Map) {
        super.mapping(map: map)

        action <- map["payload.action"]
        issue <- map["payload.issue"]
        repository <- map["payload.forkee"]
    }
}

extension IssuesPayload: DomainConvertibleType {
    var asDomain: Domain.IssuesPayload {
        return Domain.IssuesPayload(action: action,
                                    issue: issue?.asDomain,
                                    repository: repository?.asDomain)
    }
}

class MemberPayload: Payload {

    var action: String?
    var member: User?

    override func mapping(map: Map) {
        super.mapping(map: map)

        action <- map["payload.action"]
        member <- map["payload.member"]
    }
}

extension MemberPayload: DomainConvertibleType {
    var asDomain: Domain.MemberPayload {
        return Domain.MemberPayload(action: action,
                                    member: member?.asDomain)
    }
}

class PullRequestPayload: Payload {

    var action: String?
    var number: Int?
    var pullRequest: PullRequest?

    override func mapping(map: Map) {
        super.mapping(map: map)

        action <- map["payload.action"]
        number <- map["payload.number"]
        pullRequest <- map["payload.pull_request"]
    }
}

class PullRequestReviewCommentPayload: Payload {

    var action: String?
    var comment: Comment?
    var pullRequest: PullRequest?

    override func mapping(map: Map) {
        super.mapping(map: map)

        action <- map["payload.action"]
        comment <- map["payload.comment"]
        pullRequest <- map["payload.pull_request"]
    }
}

class PushPayload: Payload {

    var ref: String?
    var size: Int?
    var commits: [Commit] = []

    override func mapping(map: Map) {
        super.mapping(map: map)

        ref <- map["payload.ref"]
        size <- map["payload.size"]
        commits <- map["payload.commits"]
    }
}

class ReleasePayload: Payload {

    var action: String?
    var release: Release?

    override func mapping(map: Map) {
        super.mapping(map: map)

        action <- map["payload.action"]
        release <- map["payload.release"]
    }
}

class StarPayload: Payload {

    var action: String?

    override func mapping(map: Map) {
        super.mapping(map: map)

        action <- map["payload.action"]
    }
}
