//
//  ContributionsCellViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import Domain
import RxSwift
import RxCocoa

class ContributionsCellViewModel: DefaultTableViewCellViewModel {

    let contributionCalendar = BehaviorRelay<ContributionCalendar?>(value: nil)

    init(with title: String, detail: String, image: UIImage?, contributionCalendar: ContributionCalendar?) {
        super.init()
        self.title.accept(title)
        self.secondDetail.accept(detail)
        self.image.accept(image)
        self.contributionCalendar.accept(contributionCalendar)
    }
}
