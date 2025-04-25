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

        DispatchQueue.main.after(time: .now() + 0.01) { [self] in
            // goShot()
            // swiftJSON()
            // oslog()
            // pinVC()
            // coredata()
            // waterfall()
            // emitterable()
            // emitterable2()
            // combine()
            // imagepicker()
            deviceVC()
        }
    }

    func deviceVC() {
        let dvc = DeviceVC()
        UIApplication.shared.push(vc: dvc, animated: true)
    }

    /// imagepicker
    func imagepicker() {
        let ipVC = ImagePickerVC()
        UIApplication.shared.pushViewController(ipVC, animated: true)
    }

    /// combine
    func combine() {
        let cVC = CombineVC()
        UIApplication.shared.pushViewController(cVC, animated: true)
    }

    /// emitter
    func emitterable2() {
        let eVC = EmitterableVC2()
        UIApplication.shared.pushViewController(eVC, animated: true)
    }

    func emitterable() {
        let eVC = EmitterableVC()
        UIApplication.shared.pushViewController(eVC, animated: true)
    }

    /// waterfall
    func waterfall() {
        let wfVC = WaterfallVC()
        UIApplication.shared.pushViewController(wfVC, animated: true)
    }

    /// coredata
    func coredata() {
        let cdVC = DbTestVC()
        UIApplication.shared.pushViewController(cdVC, animated: true)
    }

    /// pinlayout
    func pinVC() {
        let pinVC = PinTestVC()
        UIApplication.shared.pushViewController(pinVC, animated: true)
    }

    /// oslog
    func oslog() {
        let logVC = LogTestVC()
        UIApplication.shared.pushViewController(logVC, animated: true)
    }

    /// swiftjson
    func swiftJSON() {
        let sfjVC = SwiftyJsonVC()
        UIApplication.shared.pushViewController(sfjVC, animated: true)
    }

    /// 截屏录屏
    func goShot() {
        let shotVC = ShotTestVC()
        UIApplication.shared.pushViewController(shotVC, animated: true)
    }

    override func clickNaviRightBtn() {
        // status-bar-height
        let val = rkAppStatus
        let val2 = rkStatusBarHeight
        print("====>1:\(val)=====2:\(val2)")

        // auto-show-hud-of-net
        /*
         print("===>click\n")
          // 网络延迟高自动出现 加载提示
         LyNetwork.shared.test("http://soluvn.com/api/home/getConfig")
         */

        // test-dic
        /*
         let dic = ["abc":123,"key":456]
         print(isDic(dic))

         let dic2:[String : Any] = ["abc":123,"key":"222"]
         print(isDic(dic2))

         let dic3:[String : Any] = [:]
         print(isDic(dic3))

         let intArray: [Int] = [1, 2, 3]
         print(isDic(intArray))
         */

        // test-array
        /*
         let intArray: [Int] = [1, 2, 3]
         print(isArray(intArray))  // 会返回 true

         let stringArray: [String] = ["a", "b"]
         print(isArray(stringArray))  // 会返回 true

         let emptyArray:Array<Any> = []
         print(isArray(emptyArray))  // 会返回 true

         let notArray: Int = 5
         print(isArray(notArray))  // 会返回 false

         let dic = ["abc":123,"key":456]
         print(isArray(dic))
         */

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
        /*
         let a = strFormat(NSNull())
         let b = strFormat("你好")
         print("====>:\(a)===>:\(b)")
         */
        //
        // print("===>safe-top:\(safeTop)===>safe-bot:\(safeBot)")

        /*
         var infoDic = Bundle.main.infoDictionary
         rkprint("or:\(infoDic!["RKTestKey"] ?? "--")")
         infoDic!["RKTestKey"] = "2222"
         rkprint("now:\(infoDic!["RKTestKey"] ?? "==")")

         rkprint("or:\(infoDic!["RKTestKey1"] ?? "--")")
         // infoDic!["RKTestKey1"] = ["akey":"value"]
         // rkprint("now:\(infoDic!["RKTestKey1"] ?? "==")")

         var testDic: [String: String] = infoDic!["RKTestKey1"] as! [String: String]
         testDic["akey"] = "234"
         infoDic!["RKTestKey1"] = testDic
         rkprint("type2:\(infoDic!["RKTestKey1"] ?? "==")")
         */

        /*
         RKNetwork.rkloadData(
             target: RKHomeApi.homeConfig,
             model: HomeConfigData.self,
             showHud: true
         ) { [self] returnData, jsonData in
             guard let info = returnData?.info, !info.isEmpty else {
                 rkShowHud(title: rkLocalized(key: "信息错误"))
                 return
             }
             self.homeModel = info[0]
             // rkprint("home:\(self.homeModel.login_type?[0] ?? "-1")")
             // rkprint("guid:\(self.homeModel.guide?.switch ?? "-1")")
             rkprint("jsonDic:%@", jsonData ?? [:])
         } failure: { _, _ in
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
