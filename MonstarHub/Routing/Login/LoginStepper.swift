//
//  MessagesStepper.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxCocoa
import RxFlow

enum LoginStep: Step {
    case list
    case dismissChildFlow
}

final class LoginStepper: Stepper {

    var steps = PublishRelay<Step>()

    var initialStep: Step {
        LoginStep.list
    }
}
