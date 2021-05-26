//
//  Content.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Domain
import Foundation
import ObjectMapper

enum ContentType: String {
    case file = "file"
    case dir = "dir"
    case symlink = "symlink"
    case submodule = "submodule"
    case unknown = ""
}

extension ContentType: Comparable {
    func priority() -> Int {
        switch self {
        case .file: return 0
        case .dir: return 1
        case .symlink: return 2
        case .submodule: return 3
        case .unknown: return 4
        }
    }
    
    static func < (lhs: ContentType, rhs: ContentType) -> Bool {
        return lhs.priority() < rhs.priority()
    }
}

struct Content: Mappable {
    
    var content: String?
    var downloadUrl: String?
    var encoding: String?
    var gitUrl: String?
    var htmlUrl: String?
    var name: String?
    var path: String?
    var sha: String?
    var size: Int?
    var type: ContentType = .unknown
    var url: String?
    var target: String?
    var submoduleGitUrl: String?
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        content <- map["content"]
        downloadUrl <- map["download_url"]
        encoding <- map["encoding"]
        gitUrl <- map["git_url"]
        htmlUrl <- map["html_url"]
        name <- map["name"]
        path <- map["path"]
        sha <- map["sha"]
        size <- map["size"]
        type <- map["type"]
        url <- map["url"]
        target <- map["target"]
        submoduleGitUrl <- map["submodule_git_url"]
    }
}

extension Content: DomainConvertibleType {
    var asDomain: Domain.Content {
        return Domain.Content(content: content,
                              downloadUrl: downloadUrl,
                              encoding: encoding,
                              gitUrl: gitUrl,
                              htmlUrl: htmlUrl,
                              name: name,
                              path: path,
                              sha: sha,
                              size: size,
                              type: Domain.ContentType(rawValue: type.rawValue)!,
                              url: url,
                              target: target,
                              submoduleGitUrl: submoduleGitUrl)
    }
}
