//
//  Release.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

public struct Release {

    public var assets: [Asset]?
    public var assetsUrl: String?
    public var author: User?
    public var body: String?
    public var createdAt: Date?
    public var draft: Bool?
    public var htmlUrl: String?
    public var id: Int?
    public var name: String?
    public var nodeId: String?
    public var prerelease: Bool?
    public var publishedAt: Date?
    public var tagName: String?
    public var tarballUrl: String?
    public var targetCommitish: String?
    public var uploadUrl: String?
    public var url: String?
    public var zipballUrl: String?

    public init(assets: [Asset]?,
         assetsUrl: String?,
         author: User?,
         body: String?,
         createdAt: Date?,
         draft: Bool?,
         htmlUrl: String?,
         id: Int?,
         name: String?,
         nodeId: String?,
         prerelease: Bool?,
         publishedAt: Date?,
         tagName: String?,
         tarballUrl: String?,
         targetCommitish: String?,
         uploadUrl: String?,
         url: String?,
         zipballUrl: String?) {

        self.assets = assets
        self.assetsUrl = assetsUrl
        self.author = author
        self.body = body
        self.createdAt = createdAt
        self.draft = draft
        self.htmlUrl = htmlUrl
        self.id = id
        self.name = name
        self.nodeId = nodeId
        self.prerelease = prerelease
        self.publishedAt = publishedAt
        self.tagName = tagName
        self.tarballUrl = tarballUrl
        self.targetCommitish = targetCommitish
        self.uploadUrl = uploadUrl
        self.url = url
        self.zipballUrl = zipballUrl
    }
}

public struct Asset {

    public var browserDownloadUrl: String?
    public var contentType: String?
    public var createdAt: String?
    public var downloadCount: Int?
    public var id: Int?
    public var label: String?
    public var name: String?
    public var nodeId: String?
    public var size: Int?
    public var state: String?
    public var updatedAt: String?
    public var uploader: User?
    public var url: String?

    public init(browserDownloadUrl: String?,
                contentType: String?,
                createdAt: String?,
                downloadCount: Int?,
                id: Int?,
                label: String?,
                name: String?,
                nodeId: String?,
                size: Int?,
                state: String?,
                updatedAt: String?,
                uploader: User?,
                url: String?) {

        self.browserDownloadUrl = browserDownloadUrl
        self.contentType = contentType
        self.createdAt = createdAt
        self.downloadCount = downloadCount
        self.id = id
        self.label = label
        self.name = name
        self.nodeId = nodeId
        self.size = size
        self.state = state
        self.updatedAt = updatedAt
        self.uploader = uploader
        self.url = url

    }

}
