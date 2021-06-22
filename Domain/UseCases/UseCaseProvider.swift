//
//  UseCaseProvider.swift
//  MonstarHub
//
//  Created by Rokon on 5/4/20.
//  Copyright © 2020 Monstarlab. All rights reserved.
//

import Foundation

public protocol UseCaseProvider {
    func makeGitHubUseCase() -> GitHubUseCase
    func makeCodeTabsUseCase() -> CodeTabsUseCase
    func makeTrendingGitHubUseCase() -> TrendingGitHubUseCase
    func makeTrendingGitHubStubbedUseCase() -> TrendingGitHubUseCase
}
