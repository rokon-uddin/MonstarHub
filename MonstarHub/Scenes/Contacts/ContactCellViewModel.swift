//
//  ContactCellViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

class ContactCellViewModel: DefaultTableViewCellViewModel {

    let contact: Contact

    init(with contact: Contact) {
        self.contact = contact
        super.init()
        title.accept(contact.name)
        let info = contact.phones + contact.emails
        detail.accept(info.joined(separator: ", "))
        image.accept(UIImage(data: contact.imageData ?? Data()) ?? R.image.icon_cell_contact_no_image()?.template)
    }
}
