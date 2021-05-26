//
//  TrendingGitHubUseCase.swift
//  Domain
//
//  Created by Rokon on 5/28/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxSwift

public protocol TrendingGitHubUseCase {
      func trendingRepositories(language: String, since: String) -> Single<[TrendingRepository]>
      func trendingDevelopers(language: String, since: String) -> Single<[TrendingUser]>
      func languages() -> Single<[Language]>
}

