//
//  RKPublicFunc.swift
//  RKProject
//
//  Created by YB007 on 2020/11/24.
//

import Foundation
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
private  func _rkTopVC(_ vc: UIViewController?) -> UIViewController? {
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
func rklayout(_ originSize:CGFloat) -> CGFloat {
    return RKLayout.layout(originSize)
}
private struct RKLayout {
    static let ratio:CGFloat = UIScreen.main.bounds.width / 375.0
    static func layout(_ number: CGFloat) -> CGFloat { return (number * ratio) }
}

// MARK: - 划线
///edge 左右边距
func rkGetLine(edge: CGFloat,superView: UIView) -> UILabel {
    let line = UILabel()
    line.backgroundColor = rkLineCor
    superView.addSubview(line)
    line.snp.makeConstraints { (make) in
        make.centerX.equalTo(superView)
        make.bottom.equalTo(superView.snp.bottom)
        make.height.equalTo(0.5)
        make.width.equalTo(superView.snp.width).offset(-edge*2)
    }
    return line
}
func rkCreateLine(edge: CGFloat,superView: UIView){
    let line = UILabel()
    line.backgroundColor = rkLineCor
    superView.addSubview(line)
    line.snp.makeConstraints { (make) in
        make.centerX.equalTo(superView)
        make.bottom.equalTo(superView.snp.bottom)
        make.height.equalTo(0.5)
        make.width.equalTo(superView.snp.width).offset(-edge*2)
    }
}

// MARK: - 根据色值返回图片
func rkImageFromColor(color: UIColor, viewSize: CGSize) -> UIImage{
    
    let rect: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
    UIGraphicsBeginImageContext(rect.size)
    let context: CGContext = UIGraphicsGetCurrentContext()!
    context.setFillColor(color.cgColor)
    context.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsGetCurrentContext()
    
    return image!
    
}

// MARK: - 获取 bundle 数据
/*eg.
 let jsonArray = readJosnArray("config")
 debugPrint("get-data:\(jsonArray.count)")
 
 let jsonDic = readJsonDic("config")
 debugPrint("get-data:\(jsonDic.keys.count)")
 */
// get dic
func readJsonDic(_ name:String)->Dictionary<String, Any> {
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
func readJosnArray(_ name:String)->Array<Any> {
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
func strFormat(_ origin:Any)->String {
    let str = String.strFormat(origin);
    return str
}
// MARK: - 数组
func isArray(_ origin: Any) -> Bool {
    let mirror = Mirror(reflecting: origin)
    if mirror.displayStyle == .collection {
        // 进一步通过类型转换判断是否为具体的数组类型
        if let _ = origin as? [Any] {
            return true
        }
    }
    return false
}
// MARK: - 字典
func isDic(_ origin: Any) -> Bool {
    let mirror = Mirror(reflecting: origin)
    if mirror.displayStyle == .dictionary {
        // 进一步通过类型转换判断是否为具体的字典类型
        if let _ = origin as? [String:Any] {
            return true
        }
    }
    return false
}
