//
//  CodetabsNetworking.swift
//  NetworkPlatform
//
//  Created by Rokon on 5/27/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper
import Moya
import Moya_ObjectMapper
import Alamofire

struct CodetabsNetworking: NetworkingType {
    typealias T = CodetabsAPI
    let provider: OnlineProvider<T>

    static func defaultNetworking() -> Self {
        return CodetabsNetworking(provider: newProvider(plugins))
    }

    static func stubbingNetworking() -> Self {
        return CodetabsNetworking(provider: OnlineProvider(endpointClosure: endpointsClosure(), requestClosure: CodetabsNetworking.endpointResolver(), stubClosure: MoyaProvider.immediatelyStub, online: .just(true)))
    }

    func request(_ token: T) -> Observable<Moya.Response> {
        let actualRequest = self.provider.request(token)
        return actualRequest
    }

    func numberOfLines(fullname: String) -> Single<[LanguageLines]> {
        return codetabsRequestArray(.numberOfLines(fullname: fullname), type: LanguageLines.self)
    }
}

extension CodetabsNetworking {
    private func codetabsRequestArray<T: BaseMappable>(_ target: CodetabsAPI, type: T.Type) -> Single<[T]> {
        return request(target)
            .mapArray(T.self)
            .observeOn(MainScheduler.instance)
            .asSingle()
    }
}
