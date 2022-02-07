//
//  RKLanguageTool.swift
//  RKProject
//
//  Created by YB007 on 2020/12/4.
//

import Foundation

import UIKit
import MJRefresh
/// 键值替换
func rkLocalized(key:String) -> String {
    let currnetL = rkLanguageType()
    let getPath = Bundle.main.path(forResource: currnetL as String, ofType: "lproj")
    guard let pathL = getPath else {
        return key
    }
    let getValue = Bundle.init(path: pathL)?.localizedString(forKey: key as String, value: nil, table: "Localizable")
    let value:String = getValue ?? key
    return value
}

/// 初始化
private let onceToken = "Method Swizzling"
func rkLanguageInit() {
    if (UserDefaults.standard.object(forKey: rkLanguageKey) == nil) {
        let languageArray = NSLocale.preferredLanguages;
        let languageStr = languageArray[0]
        if languageStr.hasPrefix(rkZhCn as String) {
            UserDefaults.standard.set(rkZhCn, forKey: rkLanguageKey)
        }else{
            UserDefaults.standard.set(rkEn, forKey: rkLanguageKey)
        }
        UserDefaults.standard.synchronize()
    }
    
    //动态设置MJ国际化
    let langClas = RKHook()
    langClas.mjLanguage()
//    langClas.hookTest()
    
}

/// 获取语言
func rkLanguageType() -> String {
    return UserDefaults.standard.object(forKey: rkLanguageKey) as! String
}

/// 切换语言
func rkSwitchLanguage() {
    let currentL = rkLanguageType()
    if currentL.isEqual(rkEn) {
        UserDefaults.standard.set(rkZhCn, forKey: rkLanguageKey)
    }else{
        UserDefaults.standard.set(rkEn, forKey: rkLanguageKey)
    }
    UserDefaults.standard.synchronize()
    
    let tabVC = RKTabBarController()
    UIApplication.shared.rkWindow?.rootViewController = tabVC
    UIApplication.shared.rkWindow?.makeKeyAndVisible()
    tabVC.selectedIndex = 4
    let setVC = RKSetVC()
    UIApplication.shared.pushViewController(setVC, animated: false)
    
}
/**
 * Swift 自定义类使用 method swizzling
 * 1.包含 swizzle 的class必须是继承自 NSObject
 * 2.swizzle 方法必须有动态属性
 */
class RKHook:NSObject {
    @objc  var aBool: Bool = true
    /// 测试方法
    @objc func hookTest(){
        var methodNum:UInt32 = 0
        let rkHook:RKHook = RKHook()
        let methodList = class_copyMethodList(object_getClass(rkHook), &methodNum)
        rkprint("method-start")
        for index in 0 ..< numericCast(methodNum) {
            
            let method: Method = methodList![index]
            rkprint(String(utf8String: method_getTypeEncoding(method)!) as Any)
            rkprint(String(utf8String: method_copyReturnType(method)) as Any)
            rkprint(String(_sel:method_getName(method)))
            rkprint("==a:\(method_getImplementation(method))")
        }
        rkprint("method-end")
        
        rkprint("property-start")
        var propertyNums:UInt32 = 0
        let propertyList = class_copyPropertyList(object_getClass(rkHook), &propertyNums)
        for index in 0 ..< numericCast(propertyNums) {
            let property:objc_property_t = propertyList![index]
            rkprint(String(utf8String: property_getName(property)) as Any)
            rkprint(String(utf8String: property_getAttributes(property)!) as Any)
        }
        rkprint("property-end")
    }
    /// 动态设置MJ的国际化
    @objc func mjLanguage() {
        DispatchQueue.once(token: onceToken) {
            let mj_selector = #selector(Bundle.mj_localizedString(forKey:value:))
            let hook_selector = #selector(self.hook_mj_localizedString(forKey:value:))
            
            let mjMethod = class_getClassMethod(Bundle.self, mj_selector)
            let hookMethod = class_getInstanceMethod(RKHook.self, hook_selector)
            method_exchangeImplementations(mjMethod!, hookMethod!)
            
            /*
            //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
            let didAddMethod: Bool = class_addMethod(Bundle.self, mj_selector, method_getImplementation(hookMethod!), method_getTypeEncoding(hookMethod!))
            //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
            if didAddMethod {
                class_replaceMethod(RKHook.self, hook_selector, method_getImplementation(mjMethod!), method_getTypeEncoding(mjMethod!))
            } else {
                method_exchangeImplementations(mjMethod!, hookMethod!)
            }
            */
        }
    }
    
    @objc dynamic func hook_mj_localizedString(forKey:String,value:String) -> String{
        let currentL = rkLanguageType()
        var mjLanguage:String = ""
        if currentL.isEqual(rkEn) {
            mjLanguage = "en"
        }else{
            mjLanguage = "zh-Hans"
        }
        let getPath = Bundle.mj_refresh().path(forResource: mjLanguage, ofType: "lproj")
        //rkprint("===kk:\(String(describing: getPath))")
        guard let pathL = getPath else {
            return currentL
        }
        let rkMjBundle = Bundle.init(path: pathL)
        guard let getMjb = rkMjBundle else {
            return currentL
        }
        let getValue = getMjb.localizedString(forKey: forKey, value: nil, table: "Localizable")
        let value:String = getValue
        //rkprint("kkkllll:\(forKey)\nbbbbb:\(value)")
        return value
    }
    
}
