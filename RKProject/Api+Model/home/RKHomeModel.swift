//
//  RKModel.swift
//  RKProject
//
//  Created by YB007 on 2020/12/9.
//

import Foundation

import HandyJSON

extension Array: HandyJSON{}
extension Dictionary :HandyJSON{}


//MARK: - homeconfig
struct HomeConfigData: HandyJSON {
    var code: Int = -1
    var msg: String = "suc"
    var info: [HomeConfigModel]?
}
struct HomeConfigModel: HandyJSON {
    var site_name: String = ""
    var site_seo_title: String = ""
    var apk_ver: String = ""
    var guide: GuideModel?
    var login_type: [String]?
}
struct GuideModel: HandyJSON {
    var `switch`: String = ""
    var type: String = ""
    var time: String = ""
}
