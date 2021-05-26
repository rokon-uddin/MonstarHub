//
//  NetworkgitHubUseCase.swift
//  NetworkPlatform
//
//  Created by Rokon on 5/4/20.
//  Copyright © 2020 Interspeed. All rights reserved.
//

import RxSwift
import Domain

struct GitHubUseCase: Domain.GitHubUseCase {
    private let network: GitHubNetworking
    
    init(network: GitHubNetworking) {
        self.network = network
    }

    func downloadString(url: URL) -> Single<String> {
        network.downloadString(url: url)
    }
    func downloadFile(url: URL, fileName: String?) -> Single<Void> {
        network.downloadFile(url: url, fileName: fileName)
    }

    // MARK: - Authentication is optional
    func createAccessToken(clientId: String, clientSecret: String, code: String, redirectUri: String?, state: String?) -> Single<Domain.Token> {
        return network.createAccessToken(clientId: clientId, clientSecret: clientSecret, code: code, redirectUri: redirectUri, state: state).map { $0.asDomain }
    }

    func searchRepositories(query: String, sort: String, order: String, page: Int, endCursor: String?) -> Single<Domain.RepositorySearch> {
        return network.searchRepositories(query: query, sort: sort, order: order, page: page, endCursor: endCursor).map { $0.asDomain }
    }

    func watchers(fullname: String, page: Int) -> Single<[Domain.User]> {
        return network.watchers(fullname: fullname, page: page).map { $0.asDomain }
    }

    func stargazers(fullname: String, page: Int) -> Single<[Domain.User]> {
        return network.stargazers(fullname: fullname, page: page).map { $0.asDomain }

    }

    func forks(fullname: String, page: Int) -> Single<[Domain.Repository]> {
        return network.forks(fullname: fullname, page: page).map { $0.asDomain }

    }

    func readme(fullname: String, ref: String?) -> Single<Domain.Content> {
        return network.readme(fullname: fullname, ref: ref).map { $0.asDomain }
    }

    func contents(fullname: String, path: String, ref: String?) -> Single<[Domain.Content]> {
        return network.contents(fullname: fullname, path: path, ref: ref).map { $0.asDomain }

    }

    func issues(fullname: String, state: String, page: Int) -> Single<[Domain.Issue]> {
        return network.issues(fullname: fullname, state: state, page: page).map { $0.asDomain }

    }

    func issue(fullname: String, number: Int) -> Single<Domain.Issue> {
        return network.issue(fullname: fullname, number: number).map { $0.asDomain }
    }

    func issueComments(fullname: String, number: Int, page: Int) -> Single<[Domain.Comment]> {
        return network.issueComments(fullname: fullname, number: number, page: page).map { $0.asDomain }
    }

    func commits(fullname: String, page: Int) -> Single<[Domain.Commit]> {
        return network.commits(fullname: fullname, page: page).map { $0.asDomain }
    }

    func commit(fullname: String, sha: String) -> Single<Domain.Commit> {
        return network.commit(fullname: fullname, sha: sha).map { $0.asDomain }
    }

    func branches(fullname: String, page: Int) -> Single<[Domain.Branch]> {
        return network.branches(fullname: fullname, page: page).map { $0.asDomain }
    }

    func branch(fullname: String, name: String) -> Single<Domain.Branch> {
        return network.branch(fullname: fullname, name: name).map { $0.asDomain }

    }

    func releases(fullname: String, page: Int) -> Single<[Domain.Release]> {
        return network.releases(fullname: fullname, page: page).map { $0.asDomain }
    }

    func release(fullname: String, releaseId: Int) -> Single<Domain.Release> {
        return network.release(fullname: fullname, releaseId: releaseId).map { $0.asDomain }

    }

    func pullRequests(fullname: String, state: String, page: Int) -> Single<[Domain.PullRequest]> {
        return network.pullRequests(fullname: fullname, state: state, page: page).map { $0.asDomain }

    }

    func pullRequest(fullname: String, number: Int) -> Single<Domain.PullRequest> {
        return network.pullRequest(fullname: fullname, number: number).map { $0.asDomain }

    }

    func pullRequestComments(fullname: String, number: Int, page: Int) -> Single<[Domain.Comment]> {
        return network.pullRequestComments(fullname: fullname, number: number, page: page).map { $0.asDomain }

    }

    func contributors(fullname: String, page: Int) -> Single<[Domain.User]> {
        return network.contributors(fullname: fullname, page: page).map { $0.asDomain }
    }

    func repository(fullname: String, qualifiedName: String) -> Single<Domain.Repository> {
        return network.repository(fullname: fullname, qualifiedName: qualifiedName).map { $0.asDomain }

    }

    func searchUsers(query: String, sort: String, order: String, page: Int, endCursor: String?) -> Single<Domain.UserSearch> {
        return network.searchUsers(query: query, sort: sort, order: order, page: page, endCursor: endCursor).map { $0.asDomain }

    }

    func user(owner: String) -> Single<Domain.User> {
        return network.user(owner: owner).map { $0.asDomain }

    }

    func organization(owner: String) -> Single<Domain.User> {
        return network.organization(owner: owner).map { $0.asDomain }

    }

    func userRepositories(username: String, page: Int) -> Single<[Domain.Repository]> {
        return network.userRepositories(username: username, page: page).map { $0.asDomain }

    }

    func userStarredRepositories(username: String, page: Int) -> Single<[Domain.Repository]> {
        return network.userStarredRepositories(username: username, page: page).map { $0.asDomain }

    }

    func userWatchingRepositories(username: String, page: Int) -> Single<[Domain.Repository]> {
        return network.userWatchingRepositories(username: username, page: page).map { $0.asDomain }

    }

    func userFollowers(username: String, page: Int) -> Single<[Domain.User]> {
        return network.userFollowers(username: username, page: page).map { $0.asDomain }

    }

    func userFollowing(username: String, page: Int) -> Single<[Domain.User]> {
        return network.userFollowing(username: username, page: page).map { $0.asDomain }

    }

    func events(page: Int) -> Single<[Domain.Event]> {
        return network.events(page: page).map { $0.asDomain }

    }

    func repositoryEvents(owner: String, repo: String, page: Int) -> Single<[Domain.Event]> {
        return network.repositoryEvents(owner: owner, repo: repo, page: page).map { $0.asDomain }

    }

    func userReceivedEvents(username: String, page: Int) -> Single<[Domain.Event]> {
        return network.userReceivedEvents(username: username, page: page).map { $0.asDomain }

    }

    func userPerformedEvents(username: String, page: Int) -> Single<[Domain.Event]> {
        return network.userPerformedEvents(username: username, page: page).map { $0.asDomain }

    }

    func organizationEvents(username: String, page: Int) -> Single<[Domain.Event]> {
        return network.organizationEvents(username: username, page: page).map { $0.asDomain }

    }

    // MARK: - Authentication is required

    func profile() -> Single<Domain.User> {
        return network.profile().map { $0.asDomain }

    }

    func notifications(all: Bool, participating: Bool, page: Int) -> Single<[Domain.Notification]> {
        return network.notifications(all: all, participating: participating, page: page).map { $0.asDomain }

    }

    func repositoryNotifications(fullname: String, all: Bool, participating: Bool, page: Int) -> Single<[Domain.Notification]> {
        return network.repositoryNotifications(fullname: fullname, all: all, participating: participating, page: page).map { $0.asDomain }

    }

    func markAsReadNotifications() -> Single<Void> {
        return network.markAsReadNotifications()

    }

    func markAsReadRepositoryNotifications(fullname: String) -> Single<Void> {
        return network.markAsReadRepositoryNotifications(fullname: fullname)

    }

    func checkStarring(fullname: String) -> Single<Void> {
        return network.checkStarring(fullname: fullname)
    }

    func starRepository(fullname: String) -> Single<Void> {
        return network.starRepository(fullname: fullname)

    }

    func unstarRepository(fullname: String) -> Single<Void> {
        return network.unstarRepository(fullname: fullname)

    }

    func checkFollowing(username: String) -> Single<Void> {
        return network.checkFollowing(username: username)

    }

    func followUser(username: String) -> Single<Void> {
        return network.followUser(username: username)

    }

    func unfollowUser(username: String) -> Single<Void> {
        return network.unfollowUser(username: username)
    }
}
