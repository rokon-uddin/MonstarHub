//
//  TrendingRepositorySteps.swift
//  MonstarHubAcceptanceTests
//
//  Created by Arman Morshed on 21/6/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import XCTest
import CucumberSwift


class TrendingRepositorySteps {
   private var selectedIndex: Int?
    private var trendingRepositoryScreen: TrendingRepositoryScreen!
    
    init() {
        trendingRepositoryScreen  = TrendingRepositoryScreen()
    }
    
    func run() {
        BeforeScenario { (_) in
            self.trendingRepositoryScreen.run()
        }
        
        Given("^the user select (.*?) no category$") { indexes, _ in
            guard let index = Int(indexes[1]) else {
                XCTFail("Can't find index from feature list")
                return
            }
            self.selectedIndex = index
        }
        
        When("^the user select the category segment$") { _, _ in
            guard let index = self.selectedIndex else  {
                XCTFail("Can't find selected index")
                return
            }
            self.trendingRepositoryScreen.tapSegmentedControl(at: index)
        }
        
        Then("^user should get the repositories by category$") {  _, _ in
            XCTAssertFalse(self.trendingRepositoryScreen.noOfItems == 0)
        }
        
        selectedIndex = nil
    }
}
