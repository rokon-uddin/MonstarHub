//
//  TrendingGitHubUseCase.swift
//  NetworkPlatform
//
//  Created by Rokon on 5/28/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxSwift
import Domain

struct TrendingGitHubUseCase: Domain.TrendingGitHubUseCase {
    private let network: TrendingGithubNetworking

    init(network: TrendingGithubNetworking) {
        self.network = network
    }

    // MARK: - Trending
    func trendingRepositories(language: String, since: String) -> Single<[Domain.TrendingRepository]> {
        return network.trendingRepositories(language: language, since: since).map { $0.asDomain }
    }

    func trendingDevelopers(language: String, since: String) -> Single<[Domain.TrendingUser]> {
        return network.trendingDevelopers(language: language, since: since).map { $0.asDomain }
    }
    
    func languages() -> Single<[Domain.Language]> {
        return network.languages().map { $0.asDomain }
    }
}


