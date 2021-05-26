//
//  SettingSwitchCellViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingSwitchCellViewModel: DefaultTableViewCellViewModel {

    let isEnabled = BehaviorRelay<Bool>(value: false)

    let switchChanged = PublishSubject<Bool>()

    init(with title: String, detail: String?, image: UIImage?, hidesDisclosure: Bool, isEnabled: Bool) {
        super.init()
        self.title.accept(title)
        self.secondDetail.accept(detail)
        self.image.accept(image)
        self.hidesDisclosure.accept(hidesDisclosure)
        self.isEnabled.accept(isEnabled)
    }
}
