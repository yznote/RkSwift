//
//  RKPrefixHeader.swift
//  RKProject
//
//  Created by YB007 on 2020/11/21.
//

import Foundation
import UIKit

@MainActor let rkScreenWidth = UIScreen.main.bounds.width
@MainActor let rkScreenHeight = UIScreen.main.bounds.height

/// 字体
let rkNaviTitleFont = UIFont.boldSystemFont(ofSize: 17)
let rkNaviItemFont = UIFont.systemFont(ofSize: 15)

/// 颜色
let rkMainCor = UIColor(hex: "#ea377f")
let rkBackGroundCor = UIColor(hex: "#f5f5f5")
let rkContentCor = UIColor(hex: "#ffffff")
let rkNaviBgCor = UIColor(hex: "#ffffff", alpha: 1.0)
let rkNaviItemCor = UIColor(hex: "#ea377f")
let rkNaviTitleCor = UIColor(hex: "#323232")
let rkLineCor = UIColor(hex: "#cccccc", alpha: 1)
let rkAlertTitleCor = UIColor(hex: "#323232")
let rkAlertContentCor = UIColor(hex: "#969696")

/// 刘海屏
@MainActor let rkIsiPhoneX = (rkScreenHeight >= 812.0)
// 44、48、47全面屏因机型不同有差异
@MainActor let rkAppStatus = UIApplication.shared.rkWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
@MainActor let rkStatusBarHeight: CGFloat = rkIsiPhoneX ? 44 : 20
@MainActor let rkNaviContentHeight: CGFloat = 44.0
@MainActor let rkNaviHeight = rkStatusBarHeight + rkNaviContentHeight

@MainActor let rkTabBarSafeSpace: CGFloat = rkIsiPhoneX ? 34.0 : 0.0
@MainActor let rkTabBarContentHeight: CGFloat = 49.0
@MainActor let rkTabBarHeight = rkTabBarSafeSpace + rkTabBarContentHeight

/// 语言
let rkLanguageKey = "rk_app_language"
let rkZhCn = "zh-Hans"
let rkEn = "en"

/// App信息
@MainActor private let rkinfoDictionary = Bundle.main.infoDictionary
@MainActor var rkdisplayName: String { return rkinfoDictionary?["CFBundleDisplayName"] as? String ?? "" }
@MainActor var rkversion: String { return rkinfoDictionary?["CFBundleShortVersionString"] as? String ?? "" }
@MainActor var rkbuild: String { return rkinfoDictionary?["CFBundleVersion"] as? String ?? "" }
@MainActor var rksystemName: String { return UIDevice.current.systemName }
@MainActor var rkbundleID: String { return Bundle.main.bundleIdentifier ?? "" }

/// 安全距离
@MainActor var safeTop = UIApplication.shared.rkWindow?.safeAreaInsets.top ?? 0
@MainActor var safeBot = UIApplication.shared.rkWindow?.safeAreaInsets.bottom ?? 0
