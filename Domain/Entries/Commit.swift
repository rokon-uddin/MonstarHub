//
//  Commit.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

public struct Commit {

    public var url: String?
    public var commentsUrl: String?
    public var commit: CommitInfo?
    public var files: [File]?
    public var htmlUrl: String?
    public var nodeId: String?
    public var sha: String?
    public var stats: Stat?
    public var author: User?
    public var committer: User?

    public init(url: String?,
                commentsUrl: String?,
                commit: CommitInfo?,
                files: [File]?,
                htmlUrl: String?,
                nodeId: String?,
                sha: String?,
                stats: Stat?,
                author: User?,
                committer: User?) {
        self.url = url
        self.commentsUrl = commentsUrl
        self.commit = commit
        self.files = files
        self.htmlUrl = htmlUrl
        self.nodeId = nodeId
        self.sha = sha
        self.stats = stats
        self.author = author
        self.committer = committer
    }
}

public struct CommitInfo {

    public var author: Committer?
    public var commentCount: Int?
    public var committer: Committer?
    public var message: String?
    public var url: String?
    public var verification: Verification?

    public init(author: Committer?,
         commentCount: Int?,
         committer: Committer?,
         message: String?,
         url: String?,
         verification: Verification?) {

        self.author = author
        self.commentCount = commentCount
        self.committer = committer
        self.message = message
        self.url = url
        self.verification = verification

    }

}

public struct Stat {

    public var additions: Int?
    public var deletions: Int?
    public var total: Int?

    public init(additions: Int?,
                deletions: Int?,
                total: Int?) {
        self.additions = additions
        self.deletions = deletions
        self.total = total
    }
}

public struct File {

    public var additions: Int?
    public var blobUrl: String?
    public var changes: Int?
    public var deletions: Int?
    public var filename: String?
    public var patch: String?
    public var rawUrl: String?
    public var status: String?

    public init(additions: Int?,
                blobUrl: String?,
                changes: Int?,
                deletions: Int?,
                filename: String?,
                patch: String?,
                rawUrl: String?,
                status: String?) {

        self.additions = additions
        self.blobUrl = blobUrl
        self.changes = changes
        self.deletions = deletions
        self.filename = filename
        self.patch = patch
        self.rawUrl = rawUrl
        self.status = status

    }
}

public struct Verification {
    public var payload: AnyObject?
    public var reason: String?
    public var signature: AnyObject?
    public var verified: Bool?

    public init(payload: AnyObject?,
                reason: String?,
                signature: AnyObject?,
                verified: Bool?) {
        self.payload = payload
        self.reason = reason
        self.signature = signature
        self.verified = verified
    }
}
