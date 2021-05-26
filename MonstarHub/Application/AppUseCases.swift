//
//  AppUseCases.swift
//  MonstarHub
//
//  Created by Rokon on 5/4/20.
//  Copyright © 2020 Monstarlab. All rights reserved.
//

import RxSwift
import Domain
import NetworkPlatform

struct AppServices: HasGitHubUseCase, HasCodeTabsUseCase, HasTrendingGitHubUseCase {

    let gitHubUseCase: GitHubUseCase
    let codeTabsUseCase: CodeTabsUseCase
    let trendingGitHubUseCase: TrendingGitHubUseCase

    init(gitHubUseCase: GitHubUseCase,
         codeTabsUseCase: CodeTabsUseCase,
         trendingGitHubUseCase: TrendingGitHubUseCase) {

        self.gitHubUseCase = gitHubUseCase
        self.codeTabsUseCase = codeTabsUseCase
        self.trendingGitHubUseCase = trendingGitHubUseCase
    }
}

protocol HasGitHubUseCase {
    var gitHubUseCase: GitHubUseCase { get }
}

protocol HasCodeTabsUseCase {
    var codeTabsUseCase: CodeTabsUseCase { get }
}

protocol HasTrendingGitHubUseCase {
    var trendingGitHubUseCase: TrendingGitHubUseCase { get }
}
