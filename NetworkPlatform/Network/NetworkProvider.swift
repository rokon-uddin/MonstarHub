//
//  NetworkProvider.swift
//  NetworkPlatform
//
//  Created by Rokon on 1/5/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation

final class NetworkProvider {

    public func makeGitHubNetwork() -> GitHubNetworking {
        return GitHubNetworking.defaultNetworking()
    }

    public func makeCodetabsNetworking() -> CodetabsNetworking {
        return CodetabsNetworking.defaultNetworking()
    }

    public func makeTrendingGithubNetwork() -> TrendingGithubNetworking {
        return TrendingGithubNetworking.defaultNetworking()
    }
}
