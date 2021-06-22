//
//  TrendingRepositoriesTests.swift
//  MonstarHubTests
//
//  Created by Arman Morshed on 21/6/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform
import XCTest
import RxSwift
import RxCocoa
@testable import MonstarHub

class when_trending_repositories_fetch_by_category: XCTestCase {
    
    var searchViewModel: SearchViewModel!
    var provider: Domain.UseCaseProvider!
    var services: AppServices!
    
    override func setUp() {
        provider = NetworkPlatform.UseCaseProvider()
        services = AppServices(gitHubUseCase: provider.makeGitHubUseCase(), codeTabsUseCase: provider.makeCodeTabsUseCase(), trendingGitHubUseCase: provider.makeTrendingGitHubStubbedUseCase())
        
        searchViewModel = SearchViewModel(services: services)
    }
    
    func test_should_return_the_daily_trending_repositories() {
        let trendingRepositories = fetchTrendingRepositoriesBy(Language.currentLanguage().value?.urlParam ?? "", since: "daily")
        print(" hello daily \(trendingRepositories.count)")
        XCTAssertTrue(trendingRepositories.count > 0)
    }
    
    func test_should_return_the_weekly_trending_repositories() {
        let trendingRepositories = fetchTrendingRepositoriesBy(Language.currentLanguage().value?.urlParam ?? "", since: "weekly")
        print(" hello weekly \(trendingRepositories.count)")
        XCTAssertTrue(trendingRepositories.count > 0)
    }
    
    func test_should_return_the_monthly_trending_repositories() {
        let trendingRepositories = fetchTrendingRepositoriesBy(Language.currentLanguage().value?.urlParam ?? "", since: "monthly")
        print(" hello monthly \(trendingRepositories.count)")
        XCTAssertTrue(trendingRepositories.count > 0)
    }
    
    override func tearDown() {
        searchViewModel = nil
        provider = nil
        services = nil
    }
    
    private func fetchTrendingRepositoriesBy(_ language: String, since: String) -> [TrendingRepository] {
        let expectation = XCTestExpectation(description: "\(since) trendings")
        var trendingRepositories = [TrendingRepository]()
        
        searchViewModel
            .services
            .trendingGitHubUseCase
            .trendingRepositories(language: language, since: since)
            .asObservable()
            .subscribe { event in
                if let repositories = event.element {
                    trendingRepositories.append(contentsOf: repositories)
                    expectation.fulfill()
                }
            }.disposed(by: rx.disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
        return trendingRepositories
    }
    
}
