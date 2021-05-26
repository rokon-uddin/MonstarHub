//
//  RootStepper.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxFlow
import RxCocoa

enum RootStep: Step {
    case main
    case welcome
    case dimissWelcome
}

class RootStepper: Stepper {

    var steps = PublishRelay<Step>()

    var initialStep: Step {
        return RootStep.main
    }
}
