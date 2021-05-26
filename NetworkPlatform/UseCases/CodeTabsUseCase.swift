//
//  CodeTabsUseCase.swift
//  NetworkPlatform
//
//  Created by Rokon on 5/28/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import RxSwift
import Domain

struct CodeTabsUseCase: Domain.CodeTabsUseCase {
    private let network: CodetabsNetworking

    init(network: CodetabsNetworking) {
        self.network = network
    }

    func numberOfLines(fullname: String) -> Single<[Domain.LanguageLines]> {
        return network.numberOfLines(fullname: fullname).map { $0.asDomain }
    }
}
