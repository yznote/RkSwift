//
//  DeviceVC.swift
//  RKProject
//
//  Created by yunbao02 on 2025/2/14.
//

import Alamofire
import CameraPermission
import DeviceKit
import MicrophonePermission
import NotificationPermission
import PermissionsKit
import PhotoLibraryPermission
import Reachability
import SwiftyGif
import SwiftyJSON
import UIKit

class DeviceVC: RKBaseVC {
    // 网络监听必须全局
    let netMonitor = NetworkReachabilityManager()
    let reachability = try! Reachability()

    var curDev = Device.current

    // gif
    let gifIV = UIImageView()
    let gifManager = SwiftyGifManager(memoryLimit: 60)

    override func viewDidLoad() {
        super.viewDidLoad()

        // ts1()
        // ts2()
        // ts3()
        // ts4()
        // ts5()
        // ts6()
        // ts7()
        // ts8()
        // ts9()
        // ts10()
        // ts11()
        ts12()
    }

    // 排序可行
    func ts12() {
        let dic: [String: Any] = [
            "id": "10",
            "name": "zhang san",
            "account": [
                "phone": 123,
                "name": "li si",
                "b":"bbb",
                "a":"aaa",
            ],
            "skip": ["jump", "stand", "run","d","b","a"],
            "lear":[
                ["id":"123","name":"网名","age":10],
                ["id":"123","nam":"网名","age":11],
                ["id":"123","nam":"网名","age":9,"b":"b"],
                ["id":"123","name":"网名","age":8,"a":"a"],
            ]
        ]
        let sortStr = manualSort(rawDic: dic, deep: true)
        debug.log("real-sort:\(sortStr)")
    }

    // json 此方式字典排序不可靠
    func ts11() {
        let dic = [
            "id": "10",
            "name": "zhang san",
            "account": ["phone": 123, "name": "li si"],
        ] as [String: Any]
        let sortedDict = dic.sorted { $0.key > $1.key }
        let orderedDict = Dictionary(uniqueKeysWithValues: sortedDict)

        let jsonDic = JSON(dic)
        let rawDic = JSON(orderedDict).rawString([.encoding: UTF8.self, .jsonSerialization: JSONSerialization.WritingOptions.prettyPrinted])
        let rawDic2 = JSON(orderedDict).rawString(.utf8, options: .prettyPrinted)
        let rawStr = JSON(rawDic2 as Any)
        let rawDic3 = sortedJSONString(from: dic) // !!! 并不能保证顺序
        debug.log("打印1：\(dic)")
        print("打印2：\(dic)")
        print("打印3：\(jsonDic.type)")
        print("打印4：\(rawDic ?? "--")")
        print("打印5：\(rawDic2 ?? "--")")
        print("打印5.1：\(rawDic3 ?? "--")")
        print("打印6：\(rawDic2 == rawDic)") // 不能保证相等，字典是无序的有可能id在前，也有可能name在前，这两者是不相等的
        print("打印7：\(rawStr.type)")

        print("打印8.1：\(sortedDict)")
        print("打印8.2：\(sortedDict)")
        print("打印9.1：\(orderedDict)")
        print("打印9.2：\(orderedDict)")
    }

    // 并不能保证有序输出 ！！！
    func sortedJSONString(from dictionary: [String: Any]) -> String? {
        let sortedDict = dictionary.sorted { $0.key < $1.key }
        let orderedDict = Dictionary(uniqueKeysWithValues: sortedDict)
        do {
            let data = try JSONSerialization.data(withJSONObject: orderedDict, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }

    // net
    func ts10() {
        //
        let postDic = [
            "abc": "123",
            "uid": "188",
        ]
        RKPhalapi.share.post(url: "Home.GetConfig", parameter: postDic) { code, info, msg in
            if code == 0 {
                rkShowHud(title: "suc")
                /*
                 let infoDic = kinfoToDic(info: info)
                 let ipa_url = infoDic["copyright_url"].stringValue
                 debug.log("ipa_url:\(ipa_url)")
                 */
                let list = kinfoToArray(info: info)
                debug.log("===>", list)
            } else {
                rkShowHud(title: msg)
            }
        } fail: {}
    }

    // gif
    func ts9() {
        /*
         let images = [
             "https://media.giphy.com/media/5tkEiBCurffluctzB7/giphy.gif",
             "2.gif",
             "https://media.giphy.com/media/5xtDarmOIekHPQSZEpq/giphy.gif",
             "3.gif",
             "https://media.giphy.com/media/3oEjHM2xehrp0lv6bC/giphy.gif",
             "5.gif",
             "https://media.giphy.com/media/l1J9qg0MqSZcQTuGk/giphy.gif",
             "4.gif",
             "http://qiniu.topan.fun/admin/20250425/b931884e2f2d72cff6631a2c885086f4.gif", // err-gif
         ]
         */

        gifIV.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        gifIV.delegate = self
        gifIV.contentMode = .scaleAspectFit
        view.addSubview(gifIV)
        // 识别为静态图
        // gifIV.setImage(UIImage(named: "2.gif")!,manager: gifManager,loopCount: -1)

        // 识别为gif
        /*
         let path = "http://qiniu.topan.fun/admin/20250425/b931884e2f2d72cff6631a2c885086f4.gif"
         if let image = try? UIImage(imageName: path) {
             gifIV.setImage(image, manager: gifManager, loopCount: 3)
         } else if let url = URL(string: path) {
             let loader = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
             gifIV.setGifFromURL(url, manager: gifManager, loopCount: 3, customLoader: loader)
         } else {
             gifIV.clear()
         }
         */
        // 使用扩展方法
        let path = "https://media.giphy.com/media/l1J9qg0MqSZcQTuGk/giphy.gif"
        gifIV.rk_image = path
    }

    // 动画2
    func ts8() {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .hex("#fff000")
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.frame = CGRect(x: rkScreenWidth - 80, y: rkScreenHeight - safeBot - 50, width: 50, height: 50)
        btn.addTarget(self, action: #selector(clickSend), for: .touchUpInside)
        view.addSubview(btn)
    }

    @objc func clickSend(btn: UIButton) {
        LikeAnimation.showTheApplauseInView(view, belowView: btn)
    }

    // Ani 动画
    func ts7() {
        let containerView = UIView(frame: CGRect(x: 0, y: rkScreenHeight - 500, width: rkScreenWidth, height: 500))
        containerView.backgroundColor = .hex("#ff0000", 0.8)
        view.addSubview(containerView)

        let thumbsUpAni = ThumbsUpAni(container: containerView)
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            thumbsUpAni.start()
        }
    }

    func ts6() {
        let _: [Permission] = [.camera, .photoLibrary, .microphone]
        // PermissionsKit.Permission.request(per)
    }

    func ts5() {
        PermissionsKit.Permission.notification([.alert, .badge]).request {
            //
            debug.log("xxxx")
        }
        let notiAuth = Permission.notification().authorized
        debug.log("noti-\(notiAuth)")
        let cameraAuth = Permission.camera.authorized
        debug.log("camera-\(cameraAuth)")
        let photoAuth = Permission.photoLibrary.authorized
        debug.log("photo-\(photoAuth)")
    }

    func ts4() {
        reachability.whenReachable = { net in
            debug.log("reachablity:connect-\(net.connection)")
        }
        reachability.whenUnreachable = { _ in
            debug.log("reachablity:not")
        }
        do {
            try reachability.startNotifier()
        } catch {
            debug.log("unable to start")
        }
    }

    func ts3() {
        netMonitor?.startListening { status in
            switch status {
                case .notReachable:
                    debug.log("1.没有网络")
                case .unknown:
                    debug.log("1.未知状态")
                case .reachable(.ethernetOrWiFi):
                    debug.log("1.已连接wifi")
                case .reachable(.cellular):
                    debug.log("1.已连接移动网络")
            }
        }
    }

    deinit {
        netMonitor?.stopListening()
        reachability.stopNotifier()
    }

    func ts2() {
        // https://github.com/sparrowcode/PermissionsKit
        // FIXME: 并未发现可以多个权限同时请求的API
        let cameraPermission = Permission.camera
        cameraPermission.request {
            //
            debug.log("finishi")
        }
    }

    func ts1() {
        debug.log("device", curDev)
        debug.log("diagonal", curDev.diagonal)
        debug.log("screenRatio", curDev.screenRatio)
        debug.log("realDevice", curDev.realDevice)
        debug.log("model", curDev.model ?? "no-model-des")
        debug.log("ppi", curDev.ppi ?? 999)
        debug.log("screenBrightness", curDev.screenBrightness)
        debug.log("safeDescription", curDev.safeDescription)
        debug.log("thermalState", curDev.thermalState ?? "")
        debug.log("cpu", curDev.cpu)
        debug.log("localizedModel", curDev.localizedModel ?? "")
        debug.log("systemName", curDev.systemName ?? "")
        debug.log("systemVersion", curDev.systemVersion ?? "")
        debug.log("volumeTotalCapacity", Device.volumeTotalCapacity ?? 999)
        debug.log("volumeAvailableCapacity", Device.volumeAvailableCapacity ?? 999)
    }
}

/// gif 动画
extension DeviceVC: SwiftyGifDelegate {
    func gifDidStart(sender: UIImageView) {
        debug.log("gif===>[start]")
    }

    func gifDidStop(sender: UIImageView) {
        debug.log("gif===>[stop]")
    }

    func gifDidLoop(sender: UIImageView) {
        debug.log("gif===>[loop]")
    }

    func gifURLDidFinish(sender: UIImageView) {
        debug.log("gif===>[finish]")
    }

    func gifURLDidFail(sender: UIImageView, url: URL, error: (any Error)?) {
        debug.log("gif===>[fail]:\(String(describing: error))")
    }
}
