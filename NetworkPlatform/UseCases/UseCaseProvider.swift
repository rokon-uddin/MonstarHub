//
//  NetworkUseCaseProvider.swift
//  NetworkPlatform
//
//  Created by Rokon on 5/4/20.
//  Copyright © 2020 Interspeed. All rights reserved.
//

import Foundation
import Domain

public struct UseCaseProvider: Domain.UseCaseProvider {
    private let networkProvider: NetworkProvider

    public init() {
        networkProvider = NetworkProvider()
    }

    public func makeGitHubUseCase() -> Domain.GitHubUseCase {
        return GitHubUseCase(network: networkProvider.makeGitHubNetwork())
    }

    public func makeCodeTabsUseCase() -> Domain.CodeTabsUseCase {
        return CodeTabsUseCase(network: networkProvider.makeCodetabsNetworking())
    }

    public func makeTrendingGitHubUseCase() -> Domain.TrendingGitHubUseCase {
        return TrendingGitHubUseCase(network: networkProvider.makeTrendingGithubNetwork())
    }
    
    public func makeTrendingGitHubStubbedUseCase() -> Domain.TrendingGitHubUseCase {
        return TrendingGitHubUseCase(network: networkProvider.makeTrendingGithubStubbedNetwork())
    }
}
