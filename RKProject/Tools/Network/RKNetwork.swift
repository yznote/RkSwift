//
//  RKNetwork.swift
//  RKProject
//
//  Created by YB007 on 2020/12/9.
//

import Foundation

import Moya
//import Result
import HandyJSON

let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<RKHomeApi>.RequestResultClosure) -> Void in
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}
let rkprovider = MoyaProvider<RKHomeApi>(requestClosure: timeoutClosure,plugins:[
    RKServicePlugin(),          //接口
    RKReqCommonParamsPlugin(),  // 拼接公共参数
    RKNetwork.rklogPlugin,      // 日志控制
])

// MARK: - 
public class RKNetwork {

    public class func rkloadData<T: TargetType, H: HandyJSON>(target: T, model: H.Type?, showHud: Bool? = nil,cache:((H?) -> Void)? = nil, success: @escaping((H?,Dictionary<String, Any>?) -> Void), failure:((Int?,String) -> Void)?){

        if let isShow = showHud {
            if isShow {
                rkLoadingHud()
            }
        }
        rkprovider.request(target as! RKHomeApi) { (result) in
            rkHideHud()
            
            switch result {
            case let .success(response):
                let netStatusCode = response.statusCode
                if netStatusCode == 200{
                    let model = try? response.rkmapModel(RKRespData<H>.self)
                    let serverRet = model?.ret
                    if serverRet == 200 {
                        let serverDataDic = model?.data?.toJSON()
                        let serverCode = serverDataDic?["code"];
                        if let serLogCode = serverCode as? Int,serLogCode == 700 {
                            rkprint("need-log")
                            /*
                            let cuss = RkProjectTestVC()
                            rkTopVC?.navigationController?.pushViewController(cuss, animated: true)
                            */
                            return
                        }
                        let dataDic = dataToDic(data: response.data )
                        var jsonDic:[String:Any] = [:]
                        if let dic = dataDic?["data"] {
                            jsonDic = dic as! [String : Any]
                        }
                        success(model?.data,jsonDic)
                    }else {
                        let erroMessage = "Service Error " + (model?.msg ?? "")
                        failureHandle(failure: failure, statusCode: serverRet, message: erroMessage)
                    }
                }else {
                    let erroMessage = "Req Error " + String(response.description)
                    failureHandle(failure: failure, statusCode: netStatusCode, message: erroMessage)
                }
            case let .failure(error):
                let erroMessage = "Net Error " + String(error.errorDescription ?? "")
                failureHandle(failure: failure, statusCode: error.errorCode, message: erroMessage)
            }
            /*
            let netStatusCode = result.value?.statusCode
            if netStatusCode == 200{
                let model = try? result.value?.rkmapModel(RKRespData<H>.self)
                let serverRet = model?.ret
                if serverRet == 200 {
                    let serverDataDic = model?.data?.toJSON()
                    let serverCode = serverDataDic?["code"];
                    if let serLogCode = serverCode as? Int,serLogCode == 700 {
                        rkprint("need-log")
                        /*
                        let cuss = RkProjectTestVC()
                        rkTopVC?.navigationController?.pushViewController(cuss, animated: true)
                        */
                        return
                    }
                    let dataDic = dataToDic(data: result.value?.data ?? Data())
                    var jsonDic:[String:Any] = [:]
                    if let dic = dataDic?["data"] {
                        jsonDic = dic as! [String : Any]
                    }
                    success(model?.data,jsonDic)
                }else {
                    let erroMessage = "Service Error " + (model?.msg ?? "")
                    failureHandle(failure: failure, statusCode: serverRet, message: erroMessage)
                }
            }else {
                let erroMessage = "Net Error " + String(result.value?.description ?? "")
                failureHandle(failure: failure, statusCode: netStatusCode, message: erroMessage)
            }
            */
            /*
            switch result {
            case let .success(response):
                let model = try? response.rkmapModel(RKRespData<H>.self)
                let jsonData = response.data
                success((model as? H),jsonData)
            case let .failure(error):
                let statusCode = error.response?.statusCode ?? -1
                let erroMessage = "Net Error" + String(statusCode) + (error.errorDescription ?? "-")
                failureHandle(failure: failure, statusCode: statusCode, message: erroMessage)
            }
            */
        }
        func failureHandle(failure:((Int?,String) -> Void)?, statusCode: Int?, message: String){
            rkShowHud(title: message)
            failure?(statusCode,message)
        }
        
        func dataToDic(data: Data)-> Dictionary<String,Any>?{
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                let dic = json as! Dictionary<String,Any>
                return dic
            } catch _ {
                return [:]
            }
        }
    }
    //打印控制
    static let rklogPlugin = RKRequestLogPlugin(isSend: false, isReq: false, isResVerbose: false, isRes: true, requestDataFormatter: {data -> String in
        return String(data: data, encoding: .utf8) ?? ""
    }) { (data) -> (Data) in
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data
        }
    }
}
extension Response {
    func rkmapModel<H: HandyJSON>(_ type: H.Type) throws -> H {
        let jsonString = String(data: data, encoding: .utf8)
        guard let model = JSONDeserializer<H>.deserializeFrom(json: jsonString) else {
            throw MoyaError.jsonMapping(self)
        }
        return model
    }
}
