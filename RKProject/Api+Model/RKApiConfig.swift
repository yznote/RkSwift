//
//  RKApiConfig.swift
//  RKProject
//
//  Created by YB007 on 2020/12/9.
//

import Foundation

import Moya

// 基本参数
public extension TargetType {
    var baseURL:URL {
        return URL(string: rkhostPath)!
    }
    var path: String{
        return ""
    }
    var headers: [String: String]? {
        return nil
    }
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
}
// 公共参数
extension URLRequest {
    private var commonParams:[String: Any]?{
        return ["uid":"666",
                "token":"token",
                "version":rkversion,
                "build":rkbuild,
                "system":rksystemName,
        ]
    }
}

// 拼接公共参数
class RKReqCommonParamsPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mutatebleReq = request
        return mutatebleReq.appendCommonParams()
    }
}
extension URLRequest {
    mutating func appendCommonParams() -> URLRequest {
        let request = try?rkencod(params: commonParams, paramsEncodeing: URLEncoding(destination: .queryString))
        assert(request != nil,"check common params value")
        return request!
    }
    mutating func appendApi(api:[String:Any]) -> URLRequest {
        let request = try?rkencod(params: api, paramsEncodeing: URLEncoding(destination: .queryString))
        assert(request != nil,"check common params value")
        return request!
    }
    func rkencod(params: [String:Any]?, paramsEncodeing: ParameterEncoding) throws -> URLRequest {
        do {
            return try paramsEncodeing.encode(self, with: params)
        } catch  {
            throw MoyaError.parameterEncoding(error)
        }
    }
}

// 拼接接口名称

class RKServicePlugin:PluginType {
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mutatebleReq = request
        var params: [String:Any] = [:]
        
        switch target {
        //配置
        case RKHomeApi.homeConfig:
            params["service"] = "home.getconfig"
            
        //直播-列表
        case RKLiveApi.liveGetLists:
            params["service"] = "Live.getLists"
        //直播-测试
        case RKLiveApi.liveTest:
            params["service"] = "Live.getlists"
            
        default:
            params["service"] = "home.getconfig"
        }
        return mutatebleReq.appendApi(api: params)
    }
    
}

