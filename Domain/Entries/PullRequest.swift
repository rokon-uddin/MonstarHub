//
//  PullRequest.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

public struct PullRequest {

    public var activeLockReason: String?
    public var additions: Int?
    public var assignee: User?
    public var assignees: [User]?
    public var authorAssociation: String?
    public var body: String?
    public var changedFiles: Int?
    public var closedAt: Date?
    public var comments: Int?
    public var commentsUrl: String?
    public var commits: Int?
    public var commitsUrl: String?
    public var createdAt: Date?
    public var deletions: Int?
    public var diffUrl: String?
    public var htmlUrl: String?
    public var id: Int?
    public var issueUrl: String?
    public var labels: [IssueLabel]?
    public var locked: Bool?
    public var maintainerCanModify: Bool?
    public var mergeCommitSha: String?
    public var mergeable: Bool?
    public var mergeableState: String?
    public var merged: Bool?
    public var mergedAt: Date?
    public var mergedBy: User?
    public var milestone: Milestone?
    public var nodeId: String?
    public var number: Int?
    public var patchUrl: String?
    public var rebaseable: Bool?
    public var requestedReviewers: [User]?
    public var reviewCommentUrl: String?
    public var reviewComments: Int?
    public var reviewCommentsUrl: String?
    public var state: State = .open
    public var statusesUrl: String?
    public var title: String?
    public var updatedAt: Date?
    public var url: String?
    public var user: User?

    public init(activeLockReason: String?,
         additions: Int?,
         assignee: User?,
         assignees: [User]?,
         authorAssociation: String?,
         body: String?,
         changedFiles: Int?,
         closedAt: Date?,
         comments: Int?,
         commentsUrl: String?,
         commits: Int?,
         commitsUrl: String?,
         createdAt: Date?,
         deletions: Int?,
         diffUrl: String?,
         htmlUrl: String?,
         id: Int?,
         issueUrl: String?,
         labels: [IssueLabel]?,
         locked: Bool?,
         maintainerCanModify: Bool?,
         mergeCommitSha: String?,
         mergeable: Bool?,
         mergeableState: String?,
         merged: Bool?,
         mergedAt: Date?,
         mergedBy: User?,
         milestone: Milestone?,
         nodeId: String?,
         number: Int?,
         patchUrl: String?,
         rebaseable: Bool?,
         requestedReviewers: [User]?,
         reviewCommentUrl: String?,
         reviewComments: Int?,
         reviewCommentsUrl: String?,
         state: State = .open,
         statusesUrl: String?,
         title: String?,
         updatedAt: Date?,
         url: String?,
         user: User?) {
        
        self.activeLockReason = activeLockReason
        self.additions = additions
        self.assignee = assignee
        self.assignees = assignees
        self.authorAssociation = authorAssociation
        self.body = body
        self.changedFiles = changedFiles
        self.closedAt = closedAt
        self.comments = comments
        self.commentsUrl = commentsUrl
        self.commits = commits
        self.commitsUrl = commitsUrl
        self.createdAt = createdAt
        self.deletions = deletions
        self.diffUrl = diffUrl
        self.htmlUrl = htmlUrl
        self.id = id
        self.issueUrl = issueUrl
        self.labels = labels
        self.locked = locked
        self.maintainerCanModify = maintainerCanModify
        self.mergeCommitSha = mergeCommitSha
        self.mergeable = mergeable
        self.mergeableState = mergeableState
        self.merged = merged
        self.mergedAt = mergedAt
        self.mergedBy = mergedBy
        self.milestone = milestone
        self.nodeId = nodeId
        self.number = number
        self.patchUrl = patchUrl
        self.rebaseable = rebaseable
        self.requestedReviewers = requestedReviewers
        self.reviewCommentUrl = reviewCommentUrl
        self.reviewComments = reviewComments
        self.reviewCommentsUrl = reviewCommentsUrl
        self.state = state
        self.statusesUrl = statusesUrl
        self.title = title
        self.updatedAt = updatedAt
        self.url = url
        self.user = user
    }
}
