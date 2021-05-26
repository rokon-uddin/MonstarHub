//
//  TrendingGithubNetworking.swift
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

struct TrendingGithubNetworking: NetworkingType {
    typealias T = TrendingGithubAPI
    let provider: OnlineProvider<T>

    static func defaultNetworking() -> Self {
        return TrendingGithubNetworking(provider: newProvider(plugins))
    }

    static func stubbingNetworking() -> Self {
        return TrendingGithubNetworking(provider: OnlineProvider(endpointClosure: endpointsClosure(), requestClosure: TrendingGithubNetworking.endpointResolver(), stubClosure: MoyaProvider.immediatelyStub, online: .just(true)))
    }

    func request(_ token: T) -> Observable<Moya.Response> {
        let actualRequest = self.provider.request(token)
        return actualRequest
    }

    private func trendingRequestObject<T: BaseMappable>(_ target: TrendingGithubAPI, type: T.Type) -> Single<T> {
        return request(target)
            .mapObject(T.self)
            .observeOn(MainScheduler.instance)
            .asSingle()
    }

    private func trendingRequestArray<T: BaseMappable>(_ target: TrendingGithubAPI, type: T.Type) -> Single<[T]> {
        return request(target)
            .mapArray(T.self)
            .observeOn(MainScheduler.instance)
            .asSingle()
    }
}


extension TrendingGithubNetworking {
    // MARK: - Trending
    func trendingRepositories(language: String, since: String) -> Single<[TrendingRepository]> {
        return trendingRequestArray(.trendingRepositories(language: language, since: since), type: TrendingRepository.self)
    }

    func trendingDevelopers(language: String, since: String) -> Single<[TrendingUser]> {
        return trendingRequestArray(.trendingDevelopers(language: language, since: since), type: TrendingUser.self)
    }

    func languages() -> Single<[Language]> {
        return trendingRequestArray(.languages, type: Language.self)
    }
}
