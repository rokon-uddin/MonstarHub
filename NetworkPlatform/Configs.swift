//
//  Configs.swift
//  NetworkPlatform
//
//  Created by Rokon on 5/24/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation

struct Configs {

    struct App {
        static let githubUrl = "https://github.com/rokon-mlbd/MonstarHub"
        static let githubScope = "user+repo+notifications+read:org"
        static let bundleIdentifier = "com.public.MonstarHub"
    }

    struct Network {
        static let useStaging = false  // set true for tests and generating screenshots with fastlane
        static let loggingEnabled = false
        static let githubBaseUrl = "https://api.github.com"
        static let trendingGithubBaseUrl = "https://gtrend.yapie.me"
        static let codetabsBaseUrl = "https://api.codetabs.com/v1"
        static let githistoryBaseUrl = "https://github.githistory.xyz"
        static let starHistoryBaseUrl = "https://star-history.t9t.io"
        static let profileSummaryBaseUrl = "https://profile-summary-for-github.com"
        static let githubSkylineBaseUrl = "https://skyline.github.com"
    }
}
