//
//  MonstarHubAcceptanceTests.swift
//  MonstarHubAcceptanceTests
//
//  Created by Arman Morshed on 22/6/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import XCTest
import Foundation
import CucumberSwift
@testable import MonstarHub

extension Cucumber: StepImplementation {
    public var bundle: Bundle {
        class ThisBundle {}
        return Bundle(for: ThisBundle.self)
    }
    
    public func setupSteps() {
        TrendingRepositorySteps().run()
    }
}
