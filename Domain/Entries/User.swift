//
//  User.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import KeychainAccess

private let userKey = "CurrentUserKey"
private let keychain = Keychain(service: "")

public enum UserType: String {
    case user = "User"
    case organization = "Organization"
}

public struct ContributionCalendar {
    public var totalContributions: Int?
    public var months: [Month]?
    public var weeks: [[ContributionDay]]?

    public init(totalContributions: Int?,
                months: [Month]?,
                weeks: [[ContributionDay]]?) {

        self.totalContributions = totalContributions
        self.months = months
        self.weeks = weeks
    }

    public struct Month {
        public var name: String?

        public init(name: String?) {
            self.name = name
        }
    }

    public struct ContributionDay {
        public var color: String?
        public var contributionCount: Int?

        public init(color: String?, contributionCount: Int?) {
            self.color = color
            self.contributionCount = contributionCount
        }
    }
}

/// User model
public struct User {

    public var avatarUrl: String?  // A URL pointing to the user's public avatar.
    public var blog: String?  // A URL pointing to the user's public website/blog.
    public var company: String?  // The user's public profile company.
    public var contributions: Int?
    public var createdAt: Date?  // Identifies the date and time when the object was created.
    public var email: String?  // The user's publicly visible profile email.
    public var followers: Int?  // Identifies the total count of followers.
    public var following: Int? // Identifies the total count of following.
    public var htmlUrl: String?  // The HTTP URL for this user
    public var location: String?  // The user's public profile location.
    public var login: String?  // The username used to login.
    public var name: String?  // The user's public profile name.
    public var type: UserType = .user
    public var updatedAt: Date?  // Identifies the date and time when the object was last updated.
    public var starredRepositoriesCount: Int?  // Identifies the total count of repositories the user has starred.
    public var repositoriesCount: Int?  // Identifies the total count of repositories that the user owns.
    public var issuesCount: Int?  // Identifies the total count of issues associated with this user
    public var watchingCount: Int?  // Identifies the total count of repositories the given user is watching
    public var viewerCanFollow: Bool?  // Whether or not the viewer is able to follow the user.
    public var viewerIsFollowing: Bool?  // Whether or not this user is followed by the viewer.
    public var isViewer: Bool?  // Whether or not this user is the viewing user.
    public var pinnedRepositories: [Repository]?  // A list of repositories this user has pinned to their profile
    public var organizations: [User]?  // A list of organizations the user belongs to.
    public var contributionCalendar: ContributionCalendar? // A calendar of this user's contributions on GitHub.

    // Only for Organization type
    public var descriptionField: String?

    // Only for User type
    public var bio: String?  // The user's public profile bio.

    // SenderType
    public var senderId: String { return login ?? "" }
    public var displayName: String { return login ?? "" }

    public init() {

    }

    public init(avatarUrl: String?,
                blog: String?,
                company: String?,
                contributions: Int?,
                createdAt: Date?,
                email: String?,
                followers: Int?,
                following: Int?,
                htmlUrl: String?,
                location: String?,
                login: String?,
                name: String?,
                type: UserType ,
                updatedAt: Date?,
                starredRepositoriesCount: Int?,
                repositoriesCount: Int?,
                issuesCount: Int?,
                watchingCount: Int?,
                viewerCanFollow: Bool?,
                viewerIsFollowing: Bool?,
                isViewer: Bool?,
                pinnedRepositories: [Repository]?,
                organizations: [User]?,
                contributionCalendar: ContributionCalendar?) {

        self.avatarUrl = avatarUrl
        self.blog = blog
        self.company = company
        self.contributions = contributions
        self.createdAt = createdAt
        self.email = email
        self.followers = followers
        self.following = following
        self.htmlUrl = htmlUrl
        self.location = location
        self.login = login
        self.name = name
        self.type = type
        self.updatedAt = updatedAt
        self.starredRepositoriesCount = starredRepositoriesCount
        self.repositoriesCount = repositoriesCount
        self.issuesCount = issuesCount
        self.watchingCount = watchingCount
        self.viewerCanFollow = viewerCanFollow
        self.viewerIsFollowing = viewerIsFollowing
        self.isViewer = isViewer
        self.pinnedRepositories = pinnedRepositories
        self.organizations = organizations
        self.contributionCalendar = contributionCalendar
    }

    public init(login: String?,
                name: String?,
                avatarUrl: String?,
                followers: Int?,
                viewerCanFollow: Bool?,
                viewerIsFollowing: Bool?) {

        self.login = login
        self.name = name
        self.avatarUrl = avatarUrl
        self.followers = followers
        self.viewerCanFollow = viewerCanFollow
        self.viewerIsFollowing = viewerIsFollowing
    }

    public init(user: TrendingUser) {
        self.init(login: user.username,
                  name: user.name,
                  avatarUrl: user.avatar,
                  followers: nil,
                  viewerCanFollow: nil,
                  viewerIsFollowing: nil)
        switch user.type {
        case .user: self.type = .user
        case .organization: self.type = .organization
        }
    }

}

extension User {
    public var isMine: Bool {
        if let isViewer = isViewer {
            return isViewer
        }
        return self == User.currentUser()
    }

    public func save() {
//        if let json = self.toJSONString() {
//            keychain[userKey] = json
//        } else {
//            logError("User can't be saved")
//        }
    }

    public static func currentUser() -> User? {
//        if let json = keychain[userKey], let user = User(JSONString: json) {
//            return user
//        }
        return nil
    }

    public static func removeCurrentUser() {
        keychain[userKey] = nil
    }
}

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.login == rhs.login
    }
}

/// UserSearch model
public struct UserSearch {

    public var items: [User] = []
    public var totalCount: Int = 0
    public var incompleteResults: Bool = false
    public var hasNextPage: Bool = false
    public var endCursor: String?

    public init() {
        
    }

    public init(items: [User],
                totalCount: Int,
                incompleteResults: Bool,
                hasNextPage: Bool,
                endCursor: String?) {

        self.items = items
        self.totalCount = totalCount
        self.incompleteResults = incompleteResults
        self.hasNextPage = hasNextPage
        self.endCursor = endCursor
    }
}



public enum TrendingUserType: String {
    case user
    case organization
}

/// TrendingUser model
public struct TrendingUser {

    public var username: String?
    public var name: String?
    public var url: String?
    public var avatar: String?
    public var repo: TrendingRepository?
    public var type: TrendingUserType = .user

    public init(username: String?,
         name: String?,
         url: String?,
         avatar: String?,
         repo: TrendingRepository?,
         type: TrendingUserType = .user) {

        self.username = username
        self.name = name
        self.url = url
        self.avatar = avatar
        self.repo = repo
        self.type = type
    }
}

extension TrendingUser: Equatable {
    public static func == (lhs: TrendingUser, rhs: TrendingUser) -> Bool {
        return lhs.username == rhs.username
    }
}
