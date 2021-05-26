//
//  BaseViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 1/4/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxSwift
import RxCocoa
import Domain
import RxFlow
import Kingfisher

protocol InputOutType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

class ViewModel: NSObject, ViewModelType, Stepper {

    var page = 1

    let loading = ActivityIndicator()
    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()
    var steps = PublishRelay<Step>()
    let error = ErrorTracker()
    let appError = PublishSubject<AppError>()

    override init() {
        super.init()

        appError.subscribe(onNext: { (error) in
            logError("\(error)")
        }).disposed(by: rx.disposeBag)
    }

    deinit {
        logDebug("\(type(of: self)): Deinited")
        logResourcesCount()
    }

    func navigateTo<E>(step: E) where E: Step {
        steps.accept(step)
    }
}
