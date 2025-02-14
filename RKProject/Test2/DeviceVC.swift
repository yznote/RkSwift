//
//  DeviceVC.swift
//  RKProject
//
//  Created by yunbao02 on 2025/2/14.
//

import CameraPermission
import DeviceKit
import MicrophonePermission
import NotificationPermission
import PermissionsKit
import PhotoLibraryPermission
import UIKit

class DeviceVC: RKBaseVC {
    var curDev = Device.current
    override func viewDidLoad() {
        super.viewDidLoad()

        // ts1()
        // ts2()
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
