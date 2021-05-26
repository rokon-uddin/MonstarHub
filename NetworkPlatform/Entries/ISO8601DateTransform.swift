//
//  ISO8601DateTransform.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import ObjectMapper
import SwifterSwift
import SwiftDate


open class ISO8601DateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String

    public init() {}

    open func transformFromJSON(_ value: Any?) -> Date? {
        if let dateString = value as? String {
            return dateString.toISODate()?.date
        }
        return nil
    }

    open func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return date.toISO()
        }
        return nil
    }
}
