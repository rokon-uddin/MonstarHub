//
//  Contact.swift
//  MonstarHub
//
//  Created by Rokon on 5/25/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Domain
import Foundation
import ObjectMapper
import Contacts

struct Contact: Mappable {

    var id: String?
    var name: String?
    var phones: [String] = []
    var emails: [String] = []

    var imageData: Data?

    init?(map: Map) {}
    init() {}

    init(with contact: CNContact) {
        id = contact.identifier
        name = [contact.givenName, contact.familyName].joined(separator: " ")
        phones = contact.phoneNumbers.map { $0.value.stringValue }
        emails = contact.emailAddresses.map { $0.value as String }
        imageData = contact.thumbnailImageData
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        phones <- map["phones"]
//        emails <- map["emails"]
        name <- map["name"]
    }
}

extension Contact: DomainConvertibleType {
    var asDomain: Domain.Contact {
        return Domain.Contact(id: id,
                              name: name,
                              phones: phones,
                              emails: emails)
    }
}
