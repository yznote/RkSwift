//
//  RKLogs.swift
//  RKProject
//
//  Created by YB007 on 2020/12/12.
//

import Foundation

import Moya
//import Result
// MARK: -
// MARK: - 日志打印
public final class RKRequestLogPlugin: PluginType {
    fileprivate let loggerId = "RKResponseLog"
    fileprivate let dateFormatString = "yy-MM-dd HH:mm:ss.SSS"
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let separator = ", "
    fileprivate let terminator = "\n"
    fileprivate let cURLTerminator = "\\\n"
    fileprivate let output: (_ separator: String, _ terminator: String, _ items: Any...) -> Void
    fileprivate let requestDataFormatter: ((Data) -> (String))?
    fileprivate let responseDataFormatter: ((Data) -> (Data))?

    /// A Boolean value determing whether response body data should be logged.
    /*
    public let isVerbose: Bool
    public let cURL: Bool
    public let isResponse: Bool
    */
    
    /// Initializes a RKRequestLogPlugin.
    /*
    public init(verbose: Bool = false, cURL: Bool = false, response: Bool = false, output: ((_ separator: String, _ terminator: String, _ items: Any...) -> Void)? = nil, requestDataFormatter: ((Data) -> (String))? = nil, responseDataFormatter: ((Data) -> (Data))? = nil) {
        self.cURL = cURL
        self.isResponse = response
        self.isVerbose = verbose
        self.output = output ?? RKRequestLogPlugin.rk_reversedPrint
        self.requestDataFormatter = requestDataFormatter
        self.responseDataFormatter = responseDataFormatter
    }
    */
    
    public let isSend: Bool
    public let isReq: Bool
    public let isResVerbose :Bool
    public let isRes: Bool
    
    public init(isSend: Bool = false, isReq: Bool = false, isResVerbose: Bool, isRes: Bool = false, output: ((_ separator: String, _ terminator: String, _ items: Any...) -> Void)? = nil, requestDataFormatter: ((Data) -> (String))? = nil, responseDataFormatter: ((Data) -> (Data))? = nil) {
        self.isSend = isSend
        self.isReq = isReq
        self.isResVerbose = isResVerbose
        self.isRes = isRes
        self.output = output ?? RKRequestLogPlugin.rk_reversedPrint
        self.requestDataFormatter = requestDataFormatter
        self.responseDataFormatter = responseDataFormatter
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        if let request = request as? CustomDebugStringConvertible, isSend { //cURL
            output(separator, terminator, request.debugDescription)
            return
        }
        rk_outputItems(rk_logNetworkRequest(request.request as URLRequest?))
    }
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if case .success(let response) = result {
            rk_outputItems(rk_logNetworkResponse(response.request, response.response, data: response.data, target: target))
        } else {
            rk_outputItems(rk_logNetworkResponse(nil,nil, data: nil, target: target))
        }
    }
    fileprivate func rk_outputItems(_ items: [String]) {
        if items.count > 0 { //isVerbose
            items.forEach { output(separator, terminator, $0) }
        } else {
            output(separator, terminator, items)
        }
    }
}
private extension RKRequestLogPlugin {
    var rk_date: String {
        dateFormatter.dateFormat = dateFormatString
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: Date())
    }
    func rk_format(_ loggerId: String, date: String, identifier: String, message: String) -> String {
        return "\(loggerId): [\(date)] \(identifier): \(message)"
    }
    func rk_logNetworkRequest(_ request: URLRequest?) -> [String] {
        var output = [String]()
        output += [rk_format(loggerId, date: rk_date, identifier: "Request", message: request?.description ?? "(invalid request)")]
        if let headers = request?.allHTTPHeaderFields ,isReq{
            output += [rk_format(loggerId, date: rk_date, identifier: "Headers", message: headers.description)]
        }
        if let bodyStream = request?.httpBodyStream ,isReq{
            output += [rk_format(loggerId, date: rk_date, identifier: "BStream", message: bodyStream.description)]
        }
        if let httpMethod = request?.httpMethod ,isReq{
            output += [rk_format(loggerId, date: rk_date, identifier: "-Method", message: httpMethod)]
        }
        if let body = request?.httpBody, let stringOutput = requestDataFormatter?(body) ?? String(data: body, encoding: .utf8), isReq {//isVerbose
            output += [rk_format(loggerId, date: rk_date, identifier: "---Body", message: stringOutput)]
        }
        return output
    }
    //func rk_logNetworkResponse(_ response: HTTPURLResponse?, data: Data?, target: TargetType) -> [String] {
    func rk_logNetworkResponse(_ request: URLRequest?, _ response: HTTPURLResponse?, data: Data?, target: TargetType) -> [String] {
        
        guard let response = response else {
           return [rk_format(loggerId, date: rk_date, identifier: "Response", message: "Received empty network response for \(target).")]
        }
        var output = [String]()
        if isResVerbose { //isResponse
            output += [rk_format(loggerId, date: rk_date, identifier: "Response", message: response.description)]
        }
        if let data = data, let stringData = String(data: responseDataFormatter?(data) ?? data, encoding: String.Encoding.utf8), isRes { //isVerbose
            //output += [stringData]
            
            var newOutput = ""
            if let exitParams = response.url {
                newOutput += String(describing: exitParams)
            }
            
            if let exitBody = request?.httpBody, let bodyOutput = requestDataFormatter?(exitBody) ?? String(data: exitBody, encoding: .utf8) {
                newOutput += bodyOutput
            }
            /*
            if let exitHeaders = request?.allHTTPHeaderFields {
                newOutput += String(format: "\n\nHeaders:%@\n", exitHeaders.description)
            }
            */
            newOutput += String(format: "\n%@",stringData)
            output += [rk_format(loggerId, date: rk_date, identifier: "--Result", message: newOutput)]
        }
        return output
    }
}
fileprivate extension RKRequestLogPlugin {
    static func rk_reversedPrint(_ separator: String, terminator: String, items: Any...) {
        for item in items {
            rkprint(item, separator: separator, terminator: terminator)
        }
    }
}

// MARK: -
// MARK: - 控制台输出
public func rkprint(_ items: Any..., separator: String = " ", terminator: String = "\n",file:String = #file ,_ line:Int = #line,time:Int = #line) {
    
#if DEBUG
    let dateFormate = DateFormatter()
    dateFormate.dateFormat = "yy-MM-dd HH:mm:ss.SSS"
    let curT = Date()
    let stringOfDate = dateFormate.string(from: curT)
    
    var fileName = (file as NSString).lastPathComponent
    fileName = fileName.replacingOccurrences(of: ".swift", with: "")
    
    //print("\n---------- \(fileName) ----------\nDate:\(stringOfDate)\nLine:\(line) \nlog:\n\(items)",terminator: separator)
    var i = 0
    let j = items.count
    for a in items {
        if i==0 {
            //print("\n---------- \(fileName) ----------\nDate:\(stringOfDate)\nLine:\(line) \nlog:")
            //print("\n---------- \(fileName)[\(line)] ----------\nDate:\(stringOfDate)\nlog:")
            //print("\n---------- RKCtrMsg ----------\nDate:\(stringOfDate)\nFile:\(fileName)\nLine:\(line)\nlog:\n-->")
            print("\n\(stringOfDate) -> \(fileName): -> line: \(line) ↓\n")
        }
        i += 1
        print(a, terminator:i == j ? terminator: separator)
    }
#endif
    
}
