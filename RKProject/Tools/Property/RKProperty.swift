//
//  RKPrefixHeader.swift
//  RKProject
//
//  Created by YB007 on 2020/11/21.
//

import Foundation
import UIKit

let rkScreenWidth = UIScreen.main.bounds.width
let rkScreenHeight = UIScreen.main.bounds.height

///字体
let rkNaviTitleFont = UIFont.boldSystemFont(ofSize: 17)
let rkNaviItemFont = UIFont.systemFont(ofSize: 15)

/// 颜色
let rkMainCor = UIColor(hexString: "#ea377f")
let rkBackGroundCor = UIColor(hexString: "#f5f5f5")
let rkContentCor = UIColor(hexString: "#ffffff")
let rkNaviBgCor = UIColor(hexString: "#ffffff", alpha: 1.0)
let rkNaviItemCor = UIColor(hexString: "#ea377f")
let rkNaviTitleCor = UIColor(hexString: "#323232")
let rkLineCor = UIColor(hexString: "#cccccc",alpha: 1)
let rkAlertTitleCor = UIColor(hexString: "#323232")
let rkAlertContentCor = UIColor(hexString: "#969696")

/// 刘海屏
let rkIsiPhoneX = (rkScreenHeight >= 812.0)

let rkStatusBarHeight:CGFloat = rkIsiPhoneX ? 44 : 20
let rkNaviContentHeight:CGFloat = 44.0
let rkNaviHeight = rkStatusBarHeight + rkNaviContentHeight

let rkTabBarSafeSpace:CGFloat = rkIsiPhoneX ? 34.0 : 0.0
let rkTabBarContentHeight:CGFloat = 49.0
let rkTabBarHeight = rkTabBarSafeSpace + rkTabBarContentHeight

/// 语言
let rkLanguageKey:String = "rk_app_language"
let rkZhCn:String = "zh-Hans"
let rkEn:String = "en"

/// App信息
private let rkinfoDictionary = Bundle.main.infoDictionary
var rkdisplayName: String { return rkinfoDictionary!["CFBundleDisplayName"] as! String  }
var rkversion: String { return rkinfoDictionary!["CFBundleShortVersionString"] as! String   }
var rkbuild: String {   return rkinfoDictionary!["CFBundleVersion"] as! String  }
var rksystemName: String {  return UIDevice.current.systemName  }






