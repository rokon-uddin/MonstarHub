//
//  Contact.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import Contacts

public struct Contact {

    public var id: String?
    public var name: String?
    public var phones: [String] = []
    public var emails: [String] = []

    public var imageData: Data?

    public init() {

    }
    
    public init(with contact: CNContact) {
        id = contact.identifier
        name = [contact.givenName, contact.familyName].joined(separator: " ")
        phones = contact.phoneNumbers.map { $0.value.stringValue }
        emails = contact.emailAddresses.map { $0.value as String }
        imageData = contact.thumbnailImageData
    }

    public init (id: String?,
                 name: String?,
                 phones: [String],
                 emails: [String]) {
        self.id = id
        self.name = name
        self.phones = phones
        self.emails = emails
    }
}
