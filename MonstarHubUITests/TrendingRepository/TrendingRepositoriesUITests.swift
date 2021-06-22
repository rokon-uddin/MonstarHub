//
//  TrendingRepositoriesUITests.swift
//  MonstarHubUITests
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
    var trendingRepositoryScreen: TrendingRepositoryScreen!
    
    override func setUp() {
        trendingRepositoryScreen = TrendingRepositoryScreen()
        trendingRepositoryScreen.run()
    }
    
    func test_should_show_the_daily_trending_repositories_in_tableView() {
        trendingRepositoryScreen.tapSegmentedControl(at: 0)
        print("\(trendingRepositoryScreen.noOfItems) daily")
        XCTAssertTrue(trendingRepositoryScreen.noOfItems > 0)
    }
    
    func test_should_show_the_weekly_trending_repositories_in_tableView() {
        trendingRepositoryScreen.tapSegmentedControl(at: 1)
        print("\(trendingRepositoryScreen.noOfItems) weekly")
        XCTAssertTrue(trendingRepositoryScreen.noOfItems > 0)
    }
    
    func test_should_show_the_monthly_trending_repositories_in_tableView() {
        trendingRepositoryScreen.tapSegmentedControl(at: 2)
        print("\(trendingRepositoryScreen.noOfItems) monthly")
        XCTAssertTrue(trendingRepositoryScreen.noOfItems > 0)
    }
    
    override func tearDown() {
       trendingRepositoryScreen = nil
    }
}
