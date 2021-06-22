//
//  TrendingRepositoryScreen.swift
//  MonstarHubUITests
//
//  Created by Arman Morshed on 22/6/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import XCTest
import Foundation

class TrendingRepositoryScreen {
    var app: XCUIApplication!
    
    init() {
        app = XCUIApplication()
    }
    
    func run() {
        app.launch()
    }
    
    func tapSegmentedControl(at index: Int) {
        let segmentedControl = app.otherElements["trendingPeriodSegmentedControl"]
        XCTAssertTrue(segmentedControl.exists)
        segmentedControl.buttons.element(boundBy: index).tap()
    }
    
    var noOfItems: Int {
        get {
           let tableView = app.tables.matching(identifier: "trendingRepositoriesTableView").element
            XCTAssertTrue(tableView.exists)
            return tableView.cells.count
        }
    }
}
