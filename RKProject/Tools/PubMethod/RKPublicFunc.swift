//
//  RKPublicFunc.swift
//  RKProject
//
//  Created by YB007 on 2020/11/24.
//

import Foundation
import SwiftyJSON
import UIKit

// MARK: - 栈顶VC
var rkTopVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = _rkTopVC(UIApplication.shared.rkWindow?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _rkTopVC(resultVC?.presentedViewController)
    }
    return resultVC
}

private func _rkTopVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _rkTopVC((vc as? UINavigationController)?.topViewController)
    } else if vc is UITabBarController {
        return _rkTopVC((vc as? UITabBarController)?.selectedViewController)
    } else {
        return vc
    }
}

// MARK: - 根据view获取父类VC
func rkNextResponsder(currentView: UIView) -> UIViewController {
    var vc: UIResponder = currentView
    while vc.isKind(of: UIViewController.self) != true {
        vc = vc.next!
    }
    return vc as! UIViewController
}

// MARK: - 尺寸大小转换【以 375 为基准】
func rklayout(_ originSize: CGFloat) -> CGFloat {
    return RKLayout.layout(originSize)
}

private enum RKLayout {
    static let ratio: CGFloat = UIScreen.main.bounds.width / 375.0
    static func layout(_ number: CGFloat) -> CGFloat { return number * ratio }
}

// MARK: - 划线
/// edge 左右边距
func rkGetLine(edge: CGFloat, superView: UIView) -> UILabel {
    let line = UILabel()
    line.backgroundColor = rkLineCor
    superView.addSubview(line)
    line.snp.makeConstraints { make in
        make.centerX.equalTo(superView)
        make.bottom.equalTo(superView.snp.bottom)
        make.height.equalTo(0.5)
        make.width.equalTo(superView.snp.width).offset(-edge * 2)
    }
    return line
}

func rkCreateLine(edge: CGFloat, superView: UIView) {
    let line = UILabel()
    line.backgroundColor = rkLineCor
    superView.addSubview(line)
    line.snp.makeConstraints { make in
        make.centerX.equalTo(superView)
        make.bottom.equalTo(superView.snp.bottom)
        make.height.equalTo(0.5)
        make.width.equalTo(superView.snp.width).offset(-edge * 2)
    }
}

// MARK: - 根据色值返回图片
func rkImageFromColor(color: UIColor, viewSize: CGSize) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
    UIGraphicsBeginImageContext(rect.size)
    let context: CGContext = UIGraphicsGetCurrentContext()!
    context.setFillColor(color.cgColor)
    context.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsGetCurrentContext()

    return image!
}

// MARK: - 获取 bundle 数据
/* eg.
 let jsonArray = readJosnArray("config")
 debugPrint("get-data:\(jsonArray.count)")

 let jsonDic = readJsonDic("config")
 debugPrint("get-data:\(jsonDic.keys.count)")
 */
// get dic
func readJsonDic(_ name: String) -> [String: Any] {
    let path = Bundle.main.path(forResource: name, ofType: "json")
    guard let path = path else { return [:] }
    let fileUrl = URL(fileURLWithPath: path)
    do {
        let data = try Data(contentsOf: fileUrl)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if let object = json as? [String: Any] {
            return object
        }
        return [:]
    } catch {
        return [:]
    }
}

// get array
func readJosnArray(_ name: String) -> [Any] {
    let path = Bundle.main.path(forResource: name, ofType: "json")
    guard let path = path else { return [] }
    let fileUrl = URL(fileURLWithPath: path)
    do {
        let data = try Data(contentsOf: fileUrl)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if let array = json as? [Any] {
            return array
        }
        return []
    } catch {
        return []
    }
}

// MARK: - 字符串
func strFormat(_ origin: Any) -> String {
    let str = String.strFormat(origin)
    return str
}

// MARK: - 数组
func isArray(_ origin: Any) -> Bool {
    /*
     let mirror = Mirror(reflecting: origin)
     if mirror.displayStyle == .collection {
         // 进一步通过类型转换判断是否为具体的数组类型
         if let _ = origin as? [Any] {
             return true
         }
     }
     return false
     */
    let mirror = Mirror(reflecting: origin)
    return mirror.displayStyle == .collection
}

// MARK: - 字典
func isDic(_ origin: Any) -> Bool {
    /*
     let mirror = Mirror(reflecting: origin)
     if mirror.displayStyle == .dictionary {
         // 进一步通过类型转换判断是否为具体的字典类型
         if let _ = origin as? [String: Any] {
             return true
         }
     }
     return false
     */
    let mirror = Mirror(reflecting: origin)
    return mirror.displayStyle == .dictionary
}

// MARK: 线程
func runOnMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}

// MARK: 类型转换
func kinfoToDic(info: Any) -> JSON {
    var infoDic: [String: Any] = [:]

    let resJson = JSON(info)
    if resJson.type == .array {
        for subJson in resJson.arrayValue {
            if subJson.type == .dictionary {
                for (key, value) in subJson.dictionaryValue {
                    infoDic[key] = value.object
                }
            }
        }
    } else if resJson.type == .dictionary {
        infoDic = resJson.dictionaryValue
    }
    return JSON(infoDic)
}

func kinfoToArray(info: Any) -> [JSON] {
    var listA: [JSON] = []
    let resJson = JSON(info)
    if resJson.type == .array {
        listA = resJson.arrayValue
    }
    return listA
}

// MARK: 字典排序,手动排序
func manualSort(rawDic: [String: Any], deep: Bool = true) -> String {
    // 检查字典是否为空，如果为空则直接返回空字符串
    guard !rawDic.isEmpty else { return "" }

    // 对字典的键进行排序
    let sortedKeyValues = rawDic.sorted { $0.key < $1.key }

    // 处理每个键值对
    let processedKeyValues = sortedKeyValues.map { key, value in
        let processedValue: String
        if deep {
            // 递归处理嵌套的值
            processedValue = processNestedValue(value)
        } else {
            // 对值进行字符串编码
            processedValue = strEncoding(rawVal: value)
        }
        return "\(key)=\(processedValue)"
    }
    // 将处理后的键值对用 & 连接成一个字符串
    return processedKeyValues.joined(separator: "&")
}

// 嵌套处理
private func processNestedValue(_ value: Any) -> String {
    // debug.log("====>将要处理：\(value)")
    if let dict = value as? [String: Any] {
        // debug.log("====>是字典：\(value)")
        // 递归处理嵌套字典
        return "{" + manualSort(rawDic: dict, deep: true) + "}"
    } else if let array = value as? [Any] {
        // 处理数组，递归处理每个元素
        let sortedArray = sortArrayElements(array)
        let arrayValues = sortedArray.map { element in
            processNestedValue(element)
        }
        return "[" + arrayValues.joined(separator: ",") + "]"
    } else if value is NSNull {
        // 处理 nil 值
        return "null"
    } else if let boolValue = value as? Bool {
        // 正确处理布尔值
        return boolValue ? "true" : "false"
    } else if let number = value as? NSNumber {
        // 正确处理数值类型
        if number.isBool {
            return number.boolValue ? "true" : "false"
        } else {
            return number.stringValue
        }
    } else if let string = value as? String {
        // debug.log("====>是字符串：\(value)")
        // 处理字符串，可能需要进行 URL 编码
        return strEncoding(rawVal: string)
    } else {
        // debug.log("====>是其他类型：\(value)")
        // 其他类型使用默认描述
        return strEncoding(rawVal: value)
    }
}

/// ===>
// 嵌套数组处理
private func sortArrayElements(_ array: [Any]) -> [Any] {
    return array.sorted { compareElements($0, $1) }
}

// 元素比较
private func compareElements(_ element1: Any, _ element2: Any) -> Bool {
    if let dict1 = element1 as? [String: Any], let dict2 = element2 as? [String: Any] {
        return compareDictionaries(dict1, dict2)
    }

    if let array1 = element1 as? [Any], let array2 = element2 as? [Any] {
        return compareArrays(array1, array2)
    }

    let str1 = stringValue(for: element1)
    let str2 = stringValue(for: element2)
    return str1 < str2
}

// 字典比较
private func compareDictionaries(_ dict1: [String: Any], _ dict2: [String: Any]) -> Bool {
    let sortedKeys1 = dict1.keys.sorted()
    let sortedKeys2 = dict2.keys.sorted()

    // 按字典序比较键列表
    for (key1, key2) in zip(sortedKeys1, sortedKeys2) {
        if key1 != key2 {
            return key1 < key2
        }
    }

    // 如果键列表长度不同，较短的字典更小
    if sortedKeys1.count != sortedKeys2.count {
        return sortedKeys1.count < sortedKeys2.count
    }

    // 键完全相同，比较对应的值
    for key in sortedKeys1 {
        let value1 = dict1[key]!
        let value2 = dict2[key]!

        if compareElements(value1, value2) {
            return true
        }

        if compareElements(value2, value1) {
            return false
        }
    }

    return false
}

// 数组内是单个元素比较
private func compareArrays(_ array1: [Any], _ array2: [Any]) -> Bool {
    for (e1, e2) in zip(array1, array2) {
        if compareElements(e1, e2) {
            return true
        }

        if compareElements(e2, e1) {
            return false
        }
    }

    return array1.count < array2.count
}

//
private func stringValue(for element: Any) -> String {
    if let dict = element as? [String: Any] {
        return manualSort(rawDic: dict, deep: true)
    } else if let array = element as? [Any] {
        let sortedArray = sortArrayElements(array)
        let arrayValues = sortedArray.map { stringValue(for: $0) }
        return "[" + arrayValues.joined(separator: ",") + "]"
    } else if element is NSNull {
        return "null"
    } else if let boolValue = element as? Bool {
        return boolValue ? "true" : "false"
    } else if let number = element as? NSNumber {
        if number.isBool {
            return number.boolValue ? "true" : "false"
        } else {
            return number.stringValue
        }
    } else if let string = element as? String {
        return string
    } else {
        return String(describing: element)
    }
}

/// <===

// 字符串转义
func strEncoding(rawVal: Any, charSet: CharacterSet = .urlQueryAllowed) -> String {
    var formatStr = ""
    if let string = rawVal as? String {
        formatStr = string
    } else {
        formatStr = String(describing: rawVal)
    }
    let resStr = formatStr.addingPercentEncoding(withAllowedCharacters: charSet) ?? formatStr
    return resStr
}

// 为 NSNumber 添加扩展来检测布尔值
extension NSNumber {
    /*
     fileprivate var isBool: Bool {
         let objCType = String(cString: self.objCType)
         return objCType == "c" || objCType == "C"
     }
     */
    var isBool: Bool {
        if let str = description as NSString? {
            return str == "true" || str == "false"
        }
        return false
    }
}

// MARK: next
