//
//  RKModelConfig.swift
//  RKProject
//
//  Created by YB007 on 2021/1/27.
//

import UIKit
import HandyJSON

// Response
struct RKRespData<H: HandyJSON>: HandyJSON {
    var ret: Int = -1
    var msg: String = "suc"
    var data: H?
}
