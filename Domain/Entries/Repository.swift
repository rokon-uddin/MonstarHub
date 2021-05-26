//
//  Repository.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

public struct Repository {

    public var archived: Bool?
    public var cloneUrl: String?
    public var createdAt: Date?  // Identifies the date and time when the object was created.
    public var defaultBranch = "master"  // The Ref name associated with the repository's default branch.
    public var descriptionField: String?  // The description of the repository.
    public var fork: Bool?  // Identifies if the repository is a fork.
    public var forks: Int?  // Identifies the total count of direct forked repositories
    public var forksCount: Int?
    public var fullname: String?  // The repository's name with owner.
    public var hasDownloads: Bool?
    public var hasIssues: Bool?
    public var hasPages: Bool?
    public var hasProjects: Bool?
    public var hasWiki: Bool?
    public var homepage: String?  // The repository's URL.
    public var htmlUrl: String?
    public var language: String?  // The name of the current language.
    public var languageColor: String?  // The color defined for the current language.
    public var languages: Languages?  // A list containing a breakdown of the language composition of the repository.
    public var license: License?
    public var name: String?  // The name of the repository.
    public var networkCount: Int?
    public var nodeId: String?
    public var openIssues: Int?
    public var openIssuesCount: Int?  // Identifies the total count of issues that have been opened in the repository.
    public var organization: User?
    public var owner: User?  // The User owner of the repository.
    public var privateField: Bool?
    public var pushedAt: String?
    public var size: Int?  // The number of kilobytes this repository occupies on disk.
    public var sshUrl: String?
    public var stargazersCount: Int?  // Identifies the total count of items who have starred this starrable.
    public var subscribersCount: Int?  // Identifies the total count of users watching the repository
    public var updatedAt: Date?  // Identifies the date and time when the object was last updated.
    public var url: String?  // The HTTP URL for this repository
    public var watchers: Int?
    public var watchersCount: Int?
    public var parentFullname: String?  // The parent repository's name with owner, if this is a fork.

    public var commitsCount: Int?  // Identifies the total count of the commits
    public var pullRequestsCount: Int?  // Identifies the total count of a list of pull requests that have been opened in the repository.
    public var branchesCount: Int?
    public var releasesCount: Int?  // Identifies the total count of releases which are dependent on this repository.
    public var contributorsCount: Int?  // Identifies the total count of Users that can be mentioned in the context of the repository.

    public var viewerHasStarred: Bool?  // Returns a boolean indicating whether the viewing user has starred this starrable.

    public init() {
        
    }

    public init(archived: Bool?,
                cloneUrl: String?,
                createdAt: Date?,
                defaultBranch: String,
                descriptionField: String?,
                fork: Bool?,
                forks: Int?,
                forksCount: Int?,
                fullname: String?,
                hasDownloads: Bool?,
                hasIssues: Bool?,
                hasPages: Bool?,
                hasProjects: Bool?,
                hasWiki: Bool?,
                homepage: String?,
                htmlUrl: String?,
                language: String?,
                languageColor: String?,
                languages: Languages?,
                license: License?,
                name: String?,
                networkCount: Int?,
                nodeId: String?,
                openIssues: Int?,
                openIssuesCount: Int?,
                organization: User?,
                owner: User?,
                privateField: Bool?,
                pushedAt: String?,
                size: Int?,
                sshUrl: String?,
                stargazersCount: Int?,
                subscribersCount: Int?,
                updatedAt: Date?,
                url: String?,
                watchers: Int?,
                watchersCount: Int?,
                parentFullname: String?,
                commitsCount: Int?,
                pullRequestsCount: Int?,
                branchesCount: Int?,
                releasesCount: Int?,
                contributorsCount: Int?,
                viewerHasStarred: Bool?) {

        self.archived = archived
        self.cloneUrl = cloneUrl
        self.createdAt = createdAt
        self.defaultBranch = defaultBranch
        self.descriptionField = descriptionField
        self.fork = fork
        self.forks = forks
        self.forksCount = forksCount
        self.fullname = fullname
        self.hasDownloads = hasDownloads
        self.hasIssues = hasIssues
        self.hasPages = hasPages
        self.hasProjects = hasProjects
        self.hasWiki = hasWiki
        self.homepage = homepage
        self.htmlUrl = htmlUrl
        self.language = language
        self.languageColor = languageColor
        self.languages = languages
        self.license = license
        self.name = name
        self.networkCount = networkCount
        self.nodeId = nodeId
        self.openIssues = openIssues
        self.openIssuesCount = openIssuesCount
        self.organization = organization
        self.owner = owner
        self.privateField = privateField
        self.pushedAt = pushedAt
        self.size = size
        self.sshUrl = sshUrl
        self.stargazersCount = stargazersCount
        self.subscribersCount = subscribersCount
        self.updatedAt = updatedAt
        self.url = url
        self.watchers = watchers
        self.watchersCount = watchersCount
        self.parentFullname = parentFullname
        self.commitsCount = commitsCount
        self.pullRequestsCount = pullRequestsCount
        self.branchesCount = branchesCount
        self.releasesCount = releasesCount
        self.contributorsCount = contributorsCount
        self.viewerHasStarred = viewerHasStarred
    }

    public init(name: String?, fullname: String?, description: String?, language: String?, languageColor: String?, stargazers: Int?, viewerHasStarred: Bool?, ownerAvatarUrl: String?) {
        self.name = name
        self.fullname = fullname
        self.descriptionField = description
        self.language = language
        self.languageColor = languageColor
        self.stargazersCount = stargazers
        self.viewerHasStarred = viewerHasStarred
        owner = User()
        owner?.avatarUrl = ownerAvatarUrl
    }

    public init(repo: TrendingRepository) {
        self.init(name: repo.name, fullname: repo.fullname, description: repo.descriptionField,
                  language: repo.language, languageColor: repo.languageColor, stargazers: repo.stars,
                  viewerHasStarred: nil, ownerAvatarUrl: repo.builtBy?.first?.avatar)
    }


    public func parentRepository() -> Repository? {
        guard let parentFullName = parentFullname else { return nil }
        var repository = Repository()
        repository.fullname = parentFullName
        return repository
    }
}


extension Repository: Equatable {
    public static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.fullname == rhs.fullname
    }
}

public struct RepositorySearch {

    public var items: [Repository] = []
    public var totalCount: Int = 0
    public var incompleteResults: Bool = false
    public var hasNextPage: Bool = false
    public var endCursor: String?

    public init() {

    }
    
    public init(items: [Repository] = [],
                totalCount: Int = 0,
                incompleteResults: Bool = false,
                hasNextPage: Bool = false,
                endCursor: String?) {

        self.items = items
        self.totalCount = totalCount
        self.incompleteResults = incompleteResults
        self.hasNextPage = hasNextPage
        self.endCursor = endCursor

    }

}

public struct TrendingRepository {

    public var author: String?
    public var name: String?
    public var url: String?
    public var descriptionField: String?
    public var language: String?
    public var languageColor: String?
    public var stars: Int?
    public var forks: Int?
    public var currentPeriodStars: Int?
    public var builtBy: [TrendingUser]?

    public var fullname: String? {
        return "\(author ?? "")/\(name ?? "")"
    }

    public var avatarUrl: String? {
        return builtBy?.first?.avatar
    }


    public init(author: String?,
                name: String?,
                url: String?,
                descriptionField: String?,
                language: String?,
                languageColor: String?,
                stars: Int?,
                forks: Int?,
                currentPeriodStars: Int?,
                builtBy: [TrendingUser]?) {
        self.author = author
        self.name = name
        self.url = url
        self.descriptionField = descriptionField
        self.language = language
        self.languageColor = languageColor
        self.stars = stars
        self.forks = forks
        self.currentPeriodStars = currentPeriodStars
        self.builtBy = builtBy
    }
}

extension TrendingRepository: Equatable {
    public static func == (lhs: TrendingRepository, rhs: TrendingRepository) -> Bool {
        return lhs.fullname == rhs.fullname
    }
}
