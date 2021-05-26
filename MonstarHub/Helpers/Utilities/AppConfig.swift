//
//  ConfigurationManager.swift
//  MonstarHub
//
//  Created by Rokon on 5/4/20.
//  Copyright © 2020 Monstarlab. All rights reserved.
//

import UIKit

class AppConfig {
    struct Configuration: Decodable {
        let name: String
        let baseURL: String
        let testFlags: TestFlags?
    }

    struct TestFlags: Decodable {
        let resetData: Bool
        let noSplash: Bool
        let applyTestData: Bool
    }

    // MARK: Shared instance
    static let shared = AppConfig()

    // MARK: Properties
    private let configuration: Configuration

    // MARK: Lifecycle

    init (name: String = "BuildConfiguration.plist") {
        guard let filePath = Bundle.main.path(forResource: name, ofType: nil),
            let fileData = FileManager.default.contents(atPath: filePath)
        else {
            fatalError("Configuration file '\(name)' not loadable!")
        }

        do {
            configuration = try PropertyListDecoder().decode(Configuration.self, from: fileData)

        } catch {
            fatalError("Configuration not decodable from '\(name)': \(error)")
        }
    }

    // MARK: Methods
    var baseURLString: String {
        return configuration.baseURL
    }

    public var configName: String {
        return configuration.name
    }
}
