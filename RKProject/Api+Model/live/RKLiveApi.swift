//
//  RKLiveApi.swift
//  RKProject
//
//  Created by YB007 on 2021/1/27.
//

import Foundation

import Moya

enum RKLiveApi {
    case liveGetLists
    case liveTest
}

//class LivePlugin: PluginType {
//    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//        var mutatebleReq = request
//        var params: [String:Any] = [:]
//        
//        switch target {
//        case RKLiveApi.liveGetLists:
//            params["service"] = "Live.getLists"
//        default:
//            params["service"] = "Live.getLists"
//        }
//        return mutatebleReq.appendApi(api: params)
//    }
//}

extension RKLiveApi: TargetType{
    
    var method: Moya.Method{
        switch self {
        case .liveGetLists:
            return .post
        default:
            return .get
        }
    }
    var task: Task {
        var params: [String:Any] = [:]
        
        switch self {
        case .liveGetLists:
            params["rk1"] = "abc"
            params["rk2"] = "abc"
            params["rk3"] = "abc"
            params["rk4"] = "abc"
        default:
            return .requestPlain
        }
        
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
}
