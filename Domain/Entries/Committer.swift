//
//  Committer.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation

public struct Committer {

    public var name: String?
    public var email: String?
    public var date: Date?

    public init(name: String?,
         email: String?,
         date: Date?) {
        self.name = name
        self.email = email
        self.date = date
    }

}
