//
//  RKPhalapi.swift
//  RKProject
//
//  Created by yunbao02 on 2025/5/20.
//

import JKCategories
import MBProgressHUD
import SwiftyJSON
import UIKit

///
let domainUrl = "http://test.pi-show.com"
let domainApi = domainUrl + "/phalapi/?service="
let Interval = 10.0
// 日志：是否打印br
let showBrLog = true
// 日志：是否打印结果
let showNorLog = true
///
typealias NetworkSuccessClosure = (Int, Any, String) -> Void
typealias NetworkFailClosure = () -> Void

class RKPhalapi: NSObject {
    @objc static let share = RKPhalapi()
    private override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // func postNetwork(withURL url: String, andParameter parameter: Any?, success successBlock: @escaping NetworkSuccessClosure, fail failBlock: @escaping NetworkFailClosure)
    @objc func post(url: String, parameter: Any?, success successBlock: @escaping NetworkSuccessClosure, fail failBlock: @escaping NetworkFailClosure) {
        guard let baseURL = (domainApi + url).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            runOnMainThread {
                failBlock()
            }
            debug.log("无效的url-1", url)
            return
        }
        var pullDic: [String: Any] = [:]
        // 参数处理
        if let param = parameter {
            if let convertedParam = param as? [String: Any] {
                pullDic = convertedParam
            } else {
                debug.log("注意：参数有可能不合法", parameter as Any)
            }
        }
        // 公共参数
        var baseDic: [String: Any] = [
            "model": UIDevice.jk_platform() ?? "--",
            "version": UIDevice.jk_build(),
            "system": UIDevice.jk_systemVersion() ?? "--",
            "language": rkLanguageType(),
            "source": "2",
        ]

        // FIXME: uid、token 的补充
        let ownID = "10000"
        let ownToken = "b8058459867fb55e3aac1d032737083a"
        if ownID.isBlank == false, ownToken.isBlank == false {
            baseDic["uid"] = ownID
            baseDic["token"] = ownToken
        }
        // 合并字典
        pullDic.merge(baseDic) { _, new in new }
        //
        guard let requestURL = URL(string: baseURL) else {
            runOnMainThread {
                failBlock()
            }
            debug.log("无效的url-2", baseURL)
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let body = JSON(pullDic).rawString() ?? ""
        guard let bodyData = body.data(using: .utf8) else {
            runOnMainThread {
                failBlock()
            }
            debug.log("无效的参数", pullDic)
            return
        }
        request.httpBody = bodyData
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("\(bodyData.count)", forHTTPHeaderField: "Content-Length")
        request.timeoutInterval = Interval
        //
        let task = URLSession.shared.dataTask(with: request) { taskData, taskResponse, taskError in
            /// hud
            DispatchQueue.main.async {
                self.hideHUD()
            }
            guard let taskData = taskData else {
                runOnMainThread {
                    failBlock()
                }
                debug.log("【Api-Error】无效的结果", "\(baseURL)&\(self.dealWithParam(pullDic))")
                return
            }
            let dict = JSON(taskData)
            if dict.type == .dictionary {
                // 正常数据
                self.dataDeal(resJson: dict, success: successBlock, fail: failBlock, api: baseURL, params: pullDic)
            } else if dict.type == .string {
                // 可能有br
                let rawStr = dict.stringValue
                self.stringDeal(rawStr: rawStr, success: successBlock, fail: failBlock, api: baseURL, params: pullDic)
            } else {
                // 可能有br
                let rawStr = String(data: taskData, encoding: .utf8)
                if let rawStr = rawStr {
                    self.stringDeal(rawStr: rawStr, success: successBlock, fail: failBlock, api: baseURL, params: pullDic)
                } else {
                    // 数据有问题
                    debug.log("【Api-Error】code:", taskError?.localizedDescription as Any, "\(baseURL)&\(self.dealWithParam(pullDic))")
                    runOnMainThread {
                        failBlock()
                    }
                }
            }
        }
        task.resume()
        /// 使用DispatchQueue定时器，5秒后检查是否显示HUD
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showHUD(task)
        }
    }

    /// hud 控制
    var isHUDShown = false
    func hideHUD() {
        if isHUDShown {
            rkHideHud()
            isHUDShown = false
        }
    }

    func showHUD(_ task: URLSessionTask) {
        if task.state == .running && !isHUDShown {
            isHUDShown = true
            rkLoadingHud()
        }
    }

    /// url化
    func dealWithParam(_ param: [String: Any]) -> String {
        let allKeys = param.keys
        if allKeys.count <= 0 {
            return ""
        }
        var result = ""
        for key in allKeys {
            if let value = param[key] {
                result.append("\(key)=\(value)&")
            }
        }
        if !result.isEmpty {
            result = String(result.dropLast())
        }
        return result
    }

    /// 结果为字符串的处理(可能有br)
    func stringDeal(rawStr: String, success successBlock: @escaping NetworkSuccessClosure, fail failBlock: @escaping NetworkFailClosure, api: String, params: [String: Any]) {
        if rawStr.contains("{\"ret\"") {
            if showBrLog {
                debug.log("出现非标准Json\(api)", rawStr)
            }
            let rawRange = rawStr.range(of: "{")!
            let newStr = String(rawStr[rawRange.lowerBound...])
            //
            let newData = newStr.data(using: .utf8)
            if let newData = newData, JSON(newData).type == .dictionary {
                let resDic = JSON(newData)
                dataDeal(resJson: resDic, success: successBlock, fail: failBlock, api: api, params: params)
            } else {
                debug.log("【Api-Error】无效的返回信息", "\(api)&\(dealWithParam(params))")
                runOnMainThread {
                    failBlock()
                }
            }
            /*
             let resDic = JSON(JSON(parseJSON: newStr))
             dataDeal(resJson: resDic, success: successBlock, fail: failBlock, api: api, params: params)
             */
        } else {
            debug.log("【Api-Error】无效的返回信息", "\(api)&\(dealWithParam(params))")
            runOnMainThread {
                failBlock()
            }
        }
    }

    /// 成功处理
    func dataDeal(resJson: JSON, success successBlock: @escaping NetworkSuccessClosure, fail failBlock: @escaping NetworkFailClosure, api: String, params: [String: Any]) {
        let ret = resJson["ret"].intValue
        let retMsg = resJson["msg"].stringValue
        if ret != 200 {
            debug.log("【Api-Error】ret:\(ret)-msg:\(retMsg)\n", "\(api)&\(dealWithParam(params))")
            runOnMainThread {
                failBlock()
            }
            return
        }
        let data = resJson["data"]
        if showNorLog {
            // debug.log("【Api-suc】", "\n【url】\(api)", "\n【params】\(self.dealWithParam(params))", "\n【res】\(data)")
            debug.log("【Api-suc】", "\n【url】\(api)&\(dealWithParam(params))", "\n【res】\(data)")
        }
        let resData = JSON(data)
        let code = resData["code"].intValue
        let info = JSON(resData["info"])
        let msg = resData["msg"].stringValue
        // 回调
        runOnMainThread {
            successBlock(code, info, msg)
        }
        // token 过期
        if code == 700 {
            runOnMainThread {
                self.hideHUD()
                // FIXME: 700处理
            }
        }
    }
}
