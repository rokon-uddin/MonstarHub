//
//  ViewModelBased.swift
//  MonstarHub
//
//  Created by Rokon on 5/4/20.
//  Copyright © 2020 Monstarlab. All rights reserved.
//

import Foundation

protocol ViewModelType { }

protocol ServicesViewModel: ViewModelType {
    associatedtype Services
    var services: Services! { get set }
}

protocol ViewModelBased: class {
    associatedtype ViewModel: ViewModelType
    var viewModel: ViewModel! { get set }
}
