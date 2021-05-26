//
//  GlobalFunctions.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxSwift

enum DebugMessageType: String {
  case info = "ℹ️"
  case warning = "⚠️"
  case error = "💥"
}

func printDebugMessage(domain: String, message: String, type: DebugMessageType = .info) {
    #if RELEASE
        return
    #endif
    debugPrint(
        type
            .rawValue
            .append(contentsOf: domain, delimiter: .space)
            .append(contentsOf: message, delimiter: .custom(string: " : "))
  )
}

@discardableResult
public func with<A: AnyObject>(_ value: A, _ configure: (A) -> Void) -> A {
    configure(value)
    return value
}
