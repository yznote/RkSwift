//
//  RKExtension.swift
//  RKProject
//
//  Created by YB007 on 2020/11/24.
//

import Foundation
import UIKit

// MARK: DispatchQueue 扩展 once 
extension DispatchQueue {
    private static var _onceTracker = [String]()
    public class func once(token: String, block: () -> ()) {
           objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
    func async(block: @escaping ()->()) {
        self.async(execute: block)
    }
    func after(time: DispatchTime, block: @escaping ()->()) {
        self.asyncAfter(deadline: time, execute: block)
    }
}

// MARK: 扩展字体 - 方便全局替换字体
extension UIFont {
    class func rkFont(ofSize fontSize: CGFloat) -> UIFont{
       return UIFont.systemFont(ofSize: fontSize)
    }
}

// MARK: - window
extension UIApplication {
    var rkWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let window = connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first{
                return window
            }else if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return (UIView() as! UIWindow)
            }
        } else {
            if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return (UIView() as! UIWindow)
            }
        }
    }
    func pushViewController(_ viewController: UIViewController, animated: Bool){
        rkTopVC?.navigationController?.pushViewController(viewController, animated: animated)
    }
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil){
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        rkTopVC?.present(viewControllerToPresent, animated:flag, completion: completion)
    }
    
}

// MARK: - 按钮 图片文字相对位置
extension UIButton {
    enum RKButtonPosition {
        case top
        case bottom
        case left
        case right
    }
    func rkImagePosition(style: RKButtonPosition ,spacing: CGFloat) {
        
        let imageWidth = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        
        labelWidth = self.titleLabel?.intrinsicContentSize.width
        labelHeight = self.titleLabel?.intrinsicContentSize.height
        
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .top:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-spacing/2, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-spacing/2, right: 0)
            break;
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
            break;
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-spacing/2, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-spacing/2, left: -imageWidth!, bottom: 0, right: 0)
            break;
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+spacing/2, bottom: 0, right: -labelWidth-spacing/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-spacing/2, bottom: 0, right: imageWidth!+spacing/2)
            break;
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}
/// UIButton 扩展，添加属性
//import ObjectiveC
private var AssociatedObjectKey: UInt8 = 0
extension UIButton {
    var extParam: Any? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKey) as Any?
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - 十六进制颜色转换
extension UIColor {
    
    /// 十六进制颜色：可以不带#，可以是一位【"1"=>"111111"】，两位【"20"=>"202020"】，三位【"123"=>"123123"】，四位、五位末尾拼接0
    /// - Parameters:
    ///   - hex: 字符串
    ///   - alpha: 透明度
    /// - Returns: UIColor
    class func hex(_ hex:String,_ alpha:CGFloat? = 1.0) -> UIColor {
        UIColor(hex: hex,alpha: alpha ?? 1)
    }
    /// 十六进制颜色：可以不带#，可以是一位【"1"=>"111111"】，两位【"20"=>"202020"】，三位【"123"=>"123123"】，四位、五位末尾拼接0
    /// - Parameters:
    ///   - hex: 字符串
    ///   - alpha: 透明度
    convenience init(hex: String, alpha: CGFloat = 1.0){
        let rgbTuple = hex.rkStringConvertRGB()
        self.init(red: rgbTuple.cRed, green: rgbTuple.cGreen, blue: rgbTuple.cBlue, alpha: alpha)
    }
}
// MARK: - String Extension
extension String {
    /// 十六进制字符串颜色转为UIColor
    func rkStringConvertColor(alpha: CGFloat = 1.0) -> UIColor {
        // 存储转换后的数值
        var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
        var hex = self
        // 如果传入的十六进制颜色有前缀，去掉前缀
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        } else if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        // 如果传入的字符数量不足6位按照后边都为0处理，当然你也可以进行其它操作
        /*
        if hex.count < 6 {
            for _ in 0..<6-hex.count {
                hex += "0"
            }
        }
        */
        if hex.count == 1 || hex.count == 2 || hex.count == 3{
            var res = ""
            for _ in 0..<6/(hex.count) {
                res += hex
            }
            hex = res;
        }else{
            for _ in 0..<6-hex.count {
                hex += "0"
            }
        }
        // 分别进行转换
        // 红
        Scanner(string: String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])).scanHexInt64(&red)
        // 绿
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])).scanHexInt64(&green)
        // 蓝
        Scanner(string: String(hex[hex.index(startIndex, offsetBy: 4)...])).scanHexInt64(&blue)
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    /// 十六进制字符串颜色转为RGB
    func rkStringConvertRGB() -> (cRed: CGFloat,cGreen: CGFloat,cBlue: CGFloat) {
        var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
        var hex = self
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        } else if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        /*
        if hex.count < 6 {
            for _ in 0..<6-hex.count {
                hex += "0"
            }
        }
        */
        // 如果传入的字符数量不足6位按照后边都为0处理，当然你也可以进行其它操作
        if hex.count == 1 || hex.count == 2 || hex.count == 3{
            var res = ""
            for _ in 0..<6/(hex.count) {
                res += hex
            }
            hex = res;
        }else{
            for _ in 0..<6-hex.count {
                hex += "0"
            }
        }
        // print("====>color:\(hex)")
        Scanner(string: String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])).scanHexInt64(&red)
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])).scanHexInt64(&green)
        Scanner(string: String(hex[hex.index(startIndex, offsetBy: 4)...])).scanHexInt64(&blue)
        return (CGFloat(red)/255.0,CGFloat(green)/255.0,CGFloat(blue)/255.0)
    }
    
    /// 字符串判空
    var isBlank: Bool {
        return allSatisfy({$0.isWhitespace})
    }
    /*
    static func strFormat(_ original:Any) -> String {
        if original is String {
            let transStr = original as! String
            if transStr.isBlank {
                return ""
            }else{
                return transStr
            }
        }else{
            return ""
        }
    }
    */
    /// 字符串格式化
    static func strFormat(_ original:Optional<Any>) -> String {
        if original is String {
            let transStr = original as! String
            if transStr.isBlank {
                return ""
            }else{
                return transStr
            }
        }else{
            return ""
        }
    }
}
/// 当字符串为可选类型时的判空处理
extension Optional where Wrapped == String {
    var isBlank: Bool{
        return self?.isBlank ?? true
    }
}

