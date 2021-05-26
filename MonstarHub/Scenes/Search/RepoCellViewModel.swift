//
//  RepoCellViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 1/6/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

class RepoCellViewModel: DefaultTableViewCellViewModel {
    let repo: Repository

    init(with repo: Repository) {
        self.repo = repo
        super.init()
        title.accept(repo.fullname)
    }
}
