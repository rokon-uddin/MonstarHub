//
//  Comment.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Domain
import Foundation
import ObjectMapper

struct Comment: Mappable {

    var authorAssociation: String?
    var body: String?
    var createdAt: Date?
    var htmlUrl: String?
    var id: Int?
    var issueUrl: String?
    var nodeId: String?
    var updatedAt: Date?
    var url: String?
    var user: User?

    // MessageType
    //    var sender: SenderType { return user ?? User() }
    //    var messageId: String { return id?.string ?? "" }
    //    var sentDate: Date { return createdAt ?? Date() }
    //    var kind: MessageKind { return .text(body ?? "") }

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        authorAssociation <- map["author_association"]
        body <- map["body"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        htmlUrl <- map["html_url"]
        id <- map["id"]
        issueUrl <- map["issue_url"]
        nodeId <- map["node_id"]
        updatedAt <- (map["updated_at"], ISO8601DateTransform())
        url <- map["url"]
        user <- map["user"]
    }
}

extension Comment: DomainConvertibleType {
    var asDomain: Domain.Comment {
        return Domain.Comment(authorAssociation: authorAssociation,
                              body: body,
                              createdAt: createdAt,
                              htmlUrl: htmlUrl,
                              id: id,
                              issueUrl: issueUrl,
                              nodeId: nodeId,
                              updatedAt: updatedAt,
                              url: url,
                              user: user?.asDomain)
    }
}
