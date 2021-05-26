//
//  Language.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation

private let languageKey = "CurrentLanguageKey"

public struct Language {

    public var urlParam: String?
    public var name: String?

    public init(urlParam: String?,
                name: String?) {
        self.urlParam = urlParam
        self.name = name
    }

    public var displayName: String {
//        return (name.isNilOrEmpty == false ? name: urlParam) ?? ""
        return ""
    }
}

extension Language {

    public func save() {
//        if let json = self.toJSONString() {
//            UserDefaults.standard.set(json, forKey: languageKey)
//        } else {
//            logError("Language can't be saved")
//        }
    }

    public static func currentLanguage() -> Language? {
//        if let json = UserDefaults.standard.string(forKey: languageKey),
//           let language = Language(JSONString: json) {
//            return language
//        }
        return nil
    }

    public static func removeCurrentLanguage() {
        UserDefaults.standard.removeObject(forKey: languageKey)
    }
}

extension Language: Equatable {
    public static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.urlParam == rhs.urlParam
    }
}

public struct Languages {

    public var totalCount: Int = 0
    public var totalSize: Int = 0
    public var languages: [RepoLanguage] = []

    public init(totalCount: Int = 0,
                totalSize: Int = 0,
                languages: [RepoLanguage] = []) {
        self.totalCount = totalCount
        self.totalSize = totalSize
        self.languages = languages
    }
}

public struct RepoLanguage {

    public var size: Int
    public var name: String?
    public var color: String?

    public init(size: Int = 0,
                name: String?,
                color: String?) {
        self.size = size
        self.name = name
        self.color = color
    }
}

public struct LanguageLines {

    public var language: String?
    public var files: Int?
    public var lines: Int?
    public var blanks: Int?
    public var comments: Int?
    public var linesOfCode: Int?

    public init(language: String?,
                files: Int?,
                lines: Int?,
                blanks: Int?,
                comments: Int?,
                linesOfCode: Int?) {
        self.language = language
        self.files = files
        self.lines = lines
        self.blanks = blanks
        self.comments = comments
        self.linesOfCode = linesOfCode

    }

}
