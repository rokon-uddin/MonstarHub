////
////  TrendingGithubNetworking.swift
////  NetworkPlatform
////
////  Created by Rokon on 1/5/21.
////  Copyright © 2021 Monstarlab. All rights reserved.
////
//
//import Foundation
//import Moya
//import RxSwift
//import Alamofire
//import Moya_ObjectMapper
//import ObjectMapper
//
//protocol RepoNetworking {
//    func searchRepositories(query: String, sort: String, order: String, page: Int, endCursor: String?) -> Single<RepositorySearch>
//}
//
//
//struct RepoNetwork: NetworkingType, RepoNetworking {
//
//    let provider: OnlineProvider<RepoApi>
//
//    static func defaultNetworking() -> Self {
//        let provider = OnlineProvider<RepoApi>(endpointClosure: RepoNetwork.endpointsClosure(nil),
//                                      requestClosure: RepoNetwork.endpointResolver(),
//                                      stubClosure: RepoNetwork.APIKeysBasedStubBehaviour,
//                                      plugins: plugins)
//        return RepoNetwork(provider: provider)
//    }
//
//    static func stubbingNetworking() -> Self {
//        return RepoNetwork(provider: OnlineProvider(endpointClosure: endpointsClosure(), requestClosure: RepoNetwork.endpointResolver(), stubClosure: MoyaProvider.immediatelyStub, online: .just(true)))
//    }
//
//    func searchRepositories(query: String, sort: String, order: String, page: Int, endCursor: String?) -> Single<RepositorySearch> {
//        return trendingRequestObject(.searchRepositories(query: query, sort: sort, order: order, page: page), type: RepositorySearch.self)
//    }
//
//    private func trendingRequestObject<T: BaseMappable>(_ target: RepoApi, type: T.Type) -> Single<T> {
//        return self.provider.request(target)
//            .mapObject(T.self)
//            .observeOn(MainScheduler.instance)
//            .asSingle()
//    }
//}
