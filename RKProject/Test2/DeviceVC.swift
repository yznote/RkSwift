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
import UIKit

class DeviceVC: RKBaseVC {
    // 网络监听必须全局
    let netMonitor = NetworkReachabilityManager()
    let reachability = try! Reachability()

    var curDev = Device.current
    override func viewDidLoad() {
        super.viewDidLoad()

        // ts1()
        // ts2()
        // ts3()
        // ts4()
        // ts5()
        // ts6()
        // ts7()
        ts8()
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
