//
//  Commit.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Domain
import Foundation
import ObjectMapper

struct Commit: Mappable {

    var url: String?
    var commentsUrl: String?
    var commit: CommitInfo?
    var files: [File]?
    var htmlUrl: String?
    var nodeId: String?
//    var parents: [Tree]?
    var sha: String?
    var stats: Stat?
    var author: User?
    var committer: User?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        url <- map["url"]
        commentsUrl <- map["comments_url"]
        commit <- map["commit"]
        files <- map["files"]
        htmlUrl <- map["html_url"]
        nodeId <- map["node_id"]
//        parents <- map["parents"]
        sha <- map["sha"]
        stats <- map["stats"]
        author <- map["author"]
        committer <- map["committer"]
    }
}

extension Commit: DomainConvertibleType {
    var asDomain: Domain.Commit {
        return Domain.Commit(url: url,
                             commentsUrl: commentsUrl,
                             commit: commit?.asDomain,
                             files: files.map { $0.asDomain },
                             htmlUrl: htmlUrl,
                             nodeId: nodeId,
                             sha: sha,
                             stats: stats?.asDomain,
                             author: author?.asDomain,
                             committer: committer?.asDomain)
    }

}

struct CommitInfo: Mappable {

    var author: Committer?
    var commentCount: Int?
    var committer: Committer?
    var message: String?
    var url: String?
    var verification: Verification?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        author <- map["author"]
        commentCount <- map["comment_count"]
        committer <- map["committer"]
        message <- map["message"]
        url <- map["url"]
        verification <- map["verification"]
    }
}

extension CommitInfo: DomainConvertibleType {
    var asDomain: Domain.CommitInfo {
        return Domain.CommitInfo(author: author?.asDomain,
                                 commentCount: commentCount,
                                 committer: committer?.asDomain,
                                 message: message,
                                 url: url,
                                 verification: verification?.asDomain)
    }
}

struct Stat: Mappable {

    var additions: Int?
    var deletions: Int?
    var total: Int?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        additions <- map["additions"]
        deletions <- map["deletions"]
        total <- map["total"]
    }
}

extension Stat: DomainConvertibleType {
    var asDomain: Domain.Stat {
        return Domain.Stat(additions: additions,
                           deletions: deletions,
                           total: total)
    }
}

struct File: Mappable {

    var additions: Int?
    var blobUrl: String?
    var changes: Int?
    var deletions: Int?
    var filename: String?
    var patch: String?
    var rawUrl: String?
    var status: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        additions <- map["additions"]
        blobUrl <- map["blob_url"]
        changes <- map["changes"]
        deletions <- map["deletions"]
        filename <- map["filename"]
        patch <- map["patch"]
        rawUrl <- map["raw_url"]
        status <- map["status"]
    }
}

extension File: DomainConvertibleType {
    var asDomain: Domain.File {
        return Domain.File(additions: additions,
                           blobUrl: blobUrl,
                           changes: changes,
                           deletions: deletions,
                           filename: filename,
                           patch: patch,
                           rawUrl: rawUrl, status: status)
    }
}

struct Verification: Mappable {

    var payload: AnyObject?
    var reason: String?
    var signature: AnyObject?
    var verified: Bool?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        payload <- map["payload"]
        reason <- map["reason"]
        signature <- map["signature"]
        verified <- map["verified"]
    }
}

extension Verification: DomainConvertibleType {
    var asDomain: Domain.Verification {
        return Domain.Verification(payload: payload,
                                   reason: reason,
                                   signature: signature,
                                   verified: verified)
    }
}
