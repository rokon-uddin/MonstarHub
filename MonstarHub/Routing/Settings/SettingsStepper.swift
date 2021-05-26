//
//  SettingsStepper.swift
//  MonstarHub
//
//  Created by Rokon on 2/1/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxCocoa
import RxFlow
import Domain

enum SettingsStep: Step {
    case list
    case dismissChildFlow

    case userDetails(user: User)
    case theme
    case language
    case contacts
    case repositoryDetails(value: Repository)

    case acknowledgementsItem
    case whatsNewItem(block: WhatsNewBlock)
}

final class SettingsStepper: Stepper {

    var steps = PublishRelay<Step>()

    var initialStep: Step {
        SettingsStep.list
    }
}
