//
//  WelcomeStepper.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxCocoa
import RxFlow

enum WelcomeStep: Step {
    case login
    case oneTimePassword
    case forgotPassword
    case setPermissions
    case dismiss
}

final class WelcomeStepper: Stepper {

    var steps = PublishRelay<Step>()

    let initialStep: Step = WelcomeStep.login
}
