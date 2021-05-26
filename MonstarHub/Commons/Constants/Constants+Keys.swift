//
//  Constants+Keys.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation

extension Constants {
    enum Keys {
        case github, mixpanel, adMob
        // TODO: Configure Keys
        var apiKey: String {
            switch self {
            case .github: return "5a39979251c0452a9476bd45c82a14d8e98c3fb3"
            case .mixpanel: return ""
            case .adMob: return ""
            }
        }

        var appId: String {
            switch self {
            case .github: return "00cbdbffb01ec72e280a"
            case .mixpanel: return ""
            case .adMob: return ""  // See GADApplicationIdentifier in Info.plist
            }
        }
    }
}

extension Constants {

    enum UserDefaults {
        static var bannersEnabled = "MonstarHub.bannersEnabled"
        static let kIsInitialLaunch = "MonstarHub.isInitialLaunch"
        static let kRefreshOnAppStartKey = "MonstarHub.refreshOnAppStart"
        static let kWeatherDataLastRefreshDateKey = "MonstarHub.lastUpdateDate"
    }

    struct App {
        static let githubUrl = "https://github.com/rokon-mlbd/MonstarHub"
        static let githubScope = "user+repo+notifications+read:org"
        static let bundleIdentifier = "com.public.MonstarHub"
    }

    struct Network {
        static let useStaging = false  // set true for tests and generating screenshots with fastlane
        static let loggingEnabled = true
        static let githubBaseUrl = "https://api.github.com"
        static let trendingGithubBaseUrl = "https://github-trending-api.now.sh"
        static let codetabsBaseUrl = "https://api.codetabs.com/v1"
        static let githistoryBaseUrl = "https://github.githistory.xyz"
        static let starHistoryBaseUrl = "https://star-history.t9t.io"
        static let profileSummaryBaseUrl = "https://profile-summary-for-github.com"
        static let githubSkylineBaseUrl = "https://skyline.github.com"
    }

    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        static let Tmp = NSTemporaryDirectory()
    }
}
