//
//  MainStepper.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxCocoa
import RxFlow

enum MainStep: Step {
  case main
}

final class MainStepper: Stepper {

  var steps = PublishRelay<Step>()

  let initialStep: Step = MainStep.main
}
