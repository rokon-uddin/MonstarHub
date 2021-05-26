//
//  Milestone.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Domain
import Foundation
import ObjectMapper

struct Milestone: Mappable {

    var closedAt: Date?
    var closedIssues: Int?
    var createdAt: Date?
    var creator: User?
    var descriptionField: String?
    var dueOn: Date?
    var htmlUrl: String?
    var id: Int?
    var labelsUrl: String?
    var nodeId: String?
    var number: Int?
    var openIssues: Int?
    var state: State = .open
    var title: String?
    var updatedAt: Date?
    var url: String?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        closedAt <- (map["closed_at"], ISO8601DateTransform())
        closedIssues <- map["closed_issues"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        creator <- map["creator"]
        descriptionField <- map["description"]
        dueOn <- (map["due_on"], ISO8601DateTransform())
        htmlUrl <- map["html_url"]
        id <- map["id"]
        labelsUrl <- map["labels_url"]
        nodeId <- map["node_id"]
        number <- map["number"]
        openIssues <- map["open_issues"]
        state <- map["state"]
        title <- map["title"]
        updatedAt <- (map["updated_at"], ISO8601DateTransform())
        url <- map["url"]
    }
}

extension Milestone: DomainConvertibleType {
    var asDomain: Domain.Milestone {
        return Domain.Milestone(closedAt: closedAt,
                                closedIssues: closedIssues,
                                createdAt: createdAt,
                                creator: creator?.asDomain,
                                descriptionField: descriptionField,
                                dueOn: dueOn,
                                htmlUrl: htmlUrl,
                                id: id,
                                labelsUrl: labelsUrl,
                                nodeId: nodeId,
                                number: number,
                                openIssues: openIssues,
                                state: Domain.State(rawValue: state.rawValue)!,
                                title: title,
                                updatedAt: updatedAt,
                                url: url)
    }
}
