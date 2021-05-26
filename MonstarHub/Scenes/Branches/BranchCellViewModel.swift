//
//  BranchCellViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

class BranchCellViewModel: DefaultTableViewCellViewModel {

    let branch: Branch

    init(with branch: Branch) {
        self.branch = branch
        super.init()
        title.accept(branch.name)
        image.accept(R.image.icon_cell_git_branch()?.template)
    }
}
