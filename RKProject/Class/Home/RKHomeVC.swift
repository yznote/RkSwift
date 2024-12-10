//
//  RKHomeVC.swift
//  RKProject
//
//  Created by YB007 on 2020/11/25.
//

import UIKit

class RKHomeVC: RKBaseVC {

    private var homeModel = HomeConfigModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleL.text = String(format: "\(rkLocalized(key: "首页%@数"))", "123")
        leftItem.isHidden = true
        
        rightItem.isHidden = false
        rightItem.setTitle(rkLocalized(key: "地址"), for: .normal)
        
        
        // print("===>safe-top:\(safeTop)===>safe-bot:\(safeBot)")
        
        
    }
    
    override func clickNaviRightBtn() {
        // test-color
        /*
        let _ = UIColor(hex: "#9")
        let _ = UIColor(hex: "1")
        let _ = UIColor(hex: "20")
        let _ = UIColor(hex: "345")
        let _ = UIColor(hex: "9876")
        let _ = UIColor(hex: "98765")
        let _ = UIColor(hex: "987654")
        
        let la = UILabel()
        la.textColor = .hex("#ff")
        */
        
        // test-str
        let a = strFormat(NSNull())
        let b = strFormat("你好")
        print("====>:\(a)===>:\(b)")
        
        //
        //print("===>safe-top:\(safeTop)===>safe-bot:\(safeBot)")
        
        /*
        var infoDic = Bundle.main.infoDictionary
        rkprint("or:\(infoDic!["RKTestKey"] ?? "--")")
        infoDic!["RKTestKey"] = "2222"
        rkprint("now:\(infoDic!["RKTestKey"] ?? "==")")
        
        rkprint("or:\(infoDic!["RKTestKey1"] ?? "--")")
//        infoDic!["RKTestKey1"] = ["akey":"value"]
//        rkprint("now:\(infoDic!["RKTestKey1"] ?? "==")")
        
        var testDic:[String:String] = infoDic!["RKTestKey1"] as! [String : String]
        testDic["akey"] = "234"
        infoDic!["RKTestKey1"] = testDic
        rkprint("type2:\(infoDic!["RKTestKey1"] ?? "==")")
        */
        /*
        RKNetwork.rkloadData(target: RKHomeApi.homeConfig, model: HomeConfigData.self, showHud: true) { [self] (returnData, jsonData) in
            guard let info = returnData?.info , info.count > 0 else {
                rkShowHud(title: rkLocalized(key: "信息错误"))
                return
            }
            self.homeModel = info[0]
//            rkprint("home:\(self.homeModel.login_type?[0] ?? "-1")")
//            rkprint("guid:\(self.homeModel.guide?.switch ?? "-1")")
            rkprint("jsonDic:%@",jsonData ?? [:])
        } failure: { (stateCode, msg) in

        }
        */
        
        /*
        let cuss = RkProjectTestVC()
        navigationController?.pushViewController(cuss, animated: true)
        */
        
        
        /*
        let web = RKWebVC(url: "http://www.baidu.com")
        navigationController?.pushViewController(web, animated: true)
        */
    }

}
