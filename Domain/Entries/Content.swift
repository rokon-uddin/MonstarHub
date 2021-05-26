//
//  Content.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

public enum ContentType: String {
    case file = "file"
    case dir = "dir"
    case symlink = "symlink"
    case submodule = "submodule"
    case unknown = ""
}

extension ContentType: Comparable {
    public func priority() -> Int {
        switch self {
        case .file: return 0
        case .dir: return 1
        case .symlink: return 2
        case .submodule: return 3
        case .unknown: return 4
        }
    }

    public static func < (lhs: ContentType, rhs: ContentType) -> Bool {
        return lhs.priority() < rhs.priority()
    }
}

public struct Content {

    public var content: String?
    public var downloadUrl: String?
    public var encoding: String?
    public var gitUrl: String?
    public var htmlUrl: String?
    public var name: String?
    public var path: String?
    public var sha: String?
    public var size: Int?
    public var type: ContentType = .unknown
    public var url: String?
    public var target: String?
    public var submoduleGitUrl: String?

    public init() {

    }
    
    public init(content: String?,
                downloadUrl: String?,
                encoding: String?,
                gitUrl: String?,
                htmlUrl: String?,
                name: String?,
                path: String?,
                sha: String?,
                size: Int?,
                type: ContentType = .unknown,
                url: String?,
                target: String?,
                submoduleGitUrl: String?) {

        self.content = content
        self.downloadUrl = downloadUrl
        self.encoding = encoding
        self.gitUrl = gitUrl
        self.htmlUrl = htmlUrl
        self.name = name
        self.path = path
        self.sha = sha
        self.size = size
        self.type =  type
        self.target = target
        self.submoduleGitUrl = submoduleGitUrl
    }
}
