//
//  RKLogs.swift
//  RKProject
//
//  Created by YB007 on 2020/12/12.
//

import Foundation
import Moya

// import Result

// MARK: -

// MARK: - 日志打印

public final class RKRequestLogPlugin: PluginType {
    fileprivate let loggerID = "RKResponseLog"
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
    public let isResVerbose: Bool
    public let isRes: Bool

    public init(
        isSend: Bool = false,
        isReq: Bool = false,
        isResVerbose: Bool,
        isRes: Bool = false,
        output: ((_ separator: String, _ terminator: String, _ items: Any...) -> Void)? = nil,
        requestDataFormatter: ((Data) -> (String))? = nil,
        responseDataFormatter: ((Data) -> (Data))? = nil
    ) {
        self.isSend = isSend
        self.isReq = isReq
        self.isResVerbose = isResVerbose
        self.isRes = isRes
        self.output = output ?? RKRequestLogPlugin.rk_reversedPrint
        self.requestDataFormatter = requestDataFormatter
        self.responseDataFormatter = responseDataFormatter
    }

    public func willSend(_ request: RequestType, target: TargetType) {
        if let request = request as? CustomDebugStringConvertible, isSend { // cURL
            output(separator, terminator, request.debugDescription)
            return
        }
        rk_outputItems(rk_logNetworkRequest(request.request as URLRequest?))
    }

    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if case .success(let response) = result {
            rk_outputItems(rk_logNetworkResponse(response.request, response.response, data: response.data, target: target))
        } else {
            rk_outputItems(rk_logNetworkResponse(nil, nil, data: nil, target: target))
        }
    }

    fileprivate func rk_outputItems(_ items: [String]) {
        if !items.isEmpty { // isVerbose
            items.forEach { output(separator, terminator, $0) }
        } else {
            output(separator, terminator, items)
        }
    }
}

extension RKRequestLogPlugin {
    fileprivate var rk_date: String {
        dateFormatter.dateFormat = dateFormatString
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: Date())
    }

    fileprivate func rk_format(_ loggerID: String, date: String, identifier: String, message: String) -> String {
        return "\(loggerID): [\(date)] \(identifier): \(message)"
    }

    fileprivate func rk_logNetworkRequest(_ request: URLRequest?) -> [String] {
        var output = [String]()
        output += [rk_format(loggerID, date: rk_date, identifier: "Request", message: request?.description ?? "(invalid request)")]
        if let headers = request?.allHTTPHeaderFields, isReq {
            output += [rk_format(loggerID, date: rk_date, identifier: "Headers", message: headers.description)]
        }
        if let bodyStream = request?.httpBodyStream, isReq {
            output += [rk_format(loggerID, date: rk_date, identifier: "BStream", message: bodyStream.description)]
        }
        if let httpMethod = request?.httpMethod, isReq {
            output += [rk_format(loggerID, date: rk_date, identifier: "-Method", message: httpMethod)]
        }
        if let body = request?.httpBody, let stringOutput = requestDataFormatter?(body) ?? String(data: body, encoding: .utf8), isReq { // isVerbose
            output += [rk_format(loggerID, date: rk_date, identifier: "---Body", message: stringOutput)]
        }
        return output
    }

    // func rk_logNetworkResponse(_ response: HTTPURLResponse?, data: Data?, target: TargetType) -> [String] {
    fileprivate func rk_logNetworkResponse(_ request: URLRequest?, _ response: HTTPURLResponse?, data: Data?, target: TargetType) -> [String] {
        guard let response = response else {
            return [rk_format(loggerID, date: rk_date, identifier: "Response", message: "Received empty network response for \(target).")]
        }
        var output = [String]()
        if isResVerbose { // isResponse
            output += [rk_format(loggerID, date: rk_date, identifier: "Response", message: response.description)]
        }
        if let data = data, let stringData = String(data: responseDataFormatter?(data) ?? data, encoding: String.Encoding.utf8), isRes { // isVerbose
            // output += [stringData]

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
            newOutput += String(format: "\n%@", stringData)
            output += [rk_format(loggerID, date: rk_date, identifier: "--Result", message: newOutput)]
        }
        return output
    }
}

extension RKRequestLogPlugin {
    fileprivate static func rk_reversedPrint(_ separator: String, terminator: String, items: Any...) {
        for item in items {
            rkprint(item, separator: separator, terminator: terminator)
        }
    }
}

// MARK: -

// MARK: - 控制台输出

public func rkprint(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, _ line: Int = #line, time: Int = #line) {
#if DEBUG
    let dateFormate = DateFormatter()
    dateFormate.dateFormat = "yy-MM-dd HH:mm:ss.SSS"
    let curT = Date()
    let stringOfDate = dateFormate.string(from: curT)

    var fileName = (file as NSString).lastPathComponent
    fileName = fileName.replacingOccurrences(of: ".swift", with: "")

    // print("\n---------- \(fileName) ----------\nDate:\(stringOfDate)\nLine:\(line) \nlog:\n\(items)",terminator: separator)
    var i = 0
    let j = items.count
    for a in items {
        if i == 0 {
            // print("\n---------- \(fileName) ----------\nDate:\(stringOfDate)\nLine:\(line) \nlog:")
            // print("\n---------- \(fileName)[\(line)] ----------\nDate:\(stringOfDate)\nlog:")
            // print("\n---------- RKCtrMsg ----------\nDate:\(stringOfDate)\nFile:\(fileName)\nLine:\(line)\nlog:\n-->")
            print("\n\(stringOfDate) -> \(fileName): -> line: \(line) ↓")
        }
        i += 1
        print(a, terminator: i == j ? terminator : separator)
    }
#endif
}

class debug {
    static func log(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, _ line: Int = #line, time: Int = #line) {
        // rkprint(items,file:file,line)
#if DEBUG
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yy-MM-dd HH:mm:ss.SSS"
        let curT = Date()
        let stringOfDate = dateFormate.string(from: curT)

        var fileName = (file as NSString).lastPathComponent
        fileName = fileName.replacingOccurrences(of: ".swift", with: "")

        // print("\n---------- \(fileName) ----------\nDate:\(stringOfDate)\nLine:\(line) \nlog:\n\(items)",terminator: separator)
        var i = 0
        let j = items.count
        for a in items {
            if i == 0 {
                // print("\n---------- \(fileName) ----------\nDate:\(stringOfDate)\nLine:\(line) \nlog:")
                // print("\n---------- \(fileName)[\(line)] ----------\nDate:\(stringOfDate)\nlog:")
                // print("\n---------- RKCtrMsg ----------\nDate:\(stringOfDate)\nFile:\(fileName)\nLine:\(line)\nlog:\n-->")
                print("\n\(stringOfDate) -> \(fileName): -> line: \(line) ↓")
            }
            i += 1
            print(a, terminator: i == j ? terminator : separator)
        }
#endif
    }
}

// MARK: - OSLog

import os.log
import OSLog
import SwiftyJSON

extension debug {
    /*
     /// 枚举
     enum OutputType {
         case debug
         case error
         case info
     }
     */
    /// 单例
    static let shared: Logger = {
        // 先定义instance为可选类型
        var instance: Logger?
        let queue = DispatchQueue(label: "com.oslog.singleton")
        queue.sync {
            // 在闭包内安全地初始化instance
            instance = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "custom-os-log")
        }
        // 使用可选绑定确保instance有值后再返回，如果没有值会触发运行时错误，不过在正常逻辑下不会出现这种情况，因为闭包内会进行初始化
        guard let unwrappedInstance = instance else {
            fatalError("Singleton instance not initialized")
        }
        return unwrappedInstance
    }()

    /// 日志输出
    /// - Parameters:
    ///   - items: 约定：当items只有一个对象时默认是打印数据,超过一个对象时默认第一个对象时标识符
    ///     items -> Examples
    /// ========
    ///     debug.log([1, 2, 3, 4, 5])
    ///     debug.log("===>flag", ["id": 1, "name": "xiaoming"], ["id": 2, "name": "xiaoli"], type: .debug)
    /// ========
    ///   - type: 类型,参考 OutputType
    ///   - file: 用于输出文件名称
    ///   - line: 用于输出代码行号
    static func log(_ items: Any..., type: OSLogType = .debug, file: String = #file, line: Int = #line) {
        //
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yy-MM-dd HH:mm:ss.SSS"
        let curT = Date()
        let stringOfDate = dateFormate.string(from: curT)
        //
        var fileName = (file as NSString).lastPathComponent
        fileName = fileName.replacingOccurrences(of: ".swift", with: "")
        //
        var logStr = "\(stringOfDate) \(fileName)【line:\(line)】"
        let separator = "\n"
        var raws = items
        if items.count > 1 {
            let first = "\(JSON(items[0]))"
            logStr += first
            logStr += separator
            raws = Array(items.dropFirst())
        } else {
            logStr += separator
        }
        logStr += raws.map { "\(JSON($0))" }.joined(separator: separator)
        //
        /*
         switch type {
         case .debug:
             shared.debug("\(logStr)")
         case .error:
             shared.fault("\(logStr)")
         case .info:
             shared.info("\(logStr)")
         case nil:
             shared.debug("\(logStr)")
         }
         */
        shared.log(level: type, "\(logStr)")
    }
}
