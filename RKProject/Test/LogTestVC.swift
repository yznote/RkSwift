//
//  LogTestVC.swift
//  RKProject
//
//  Created by yunbao02 on 2025/1/8.
//

import OSLog
import SwiftyJSON
import UIKit

class LogTestVC: RKBaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        // testlog()
        customlog()
    }

    /// custom
    func customlog() {
        debug.log("===>111", ["id": 1, "name": "xiaoming"], ["id": 2, "name": "xiaoli"], type: .error)

        debug.log("===>222", ["id": 111, "name": "xiaoli"], type: .debug)
        debug.log("===>333", ["id": 222, "name": "xiaoli"])
        debug.log("===>555\(["id": 222, "name": "xiaoli"])")
        debug.log("===>666", [10, 9, 8, 7, 6])
        debug.log("===>777", JSON([10, 9, 8, 7, 6]))

        debug.log(rkdisplayName)
        debug.log(rkbundleID)

        debug.log("one", [1])
        debug.log([2, 3])
    }

    /// raw
    func testlog() {
        let logger = Logger(
            subsystem: "logger.onevcat.com",
            category: "main"
        )

        let flag: [String: Any] = ["key": 123, "id": "345"]

        logger.info("This is an info")
        logger.warning("Ummm...seems not that good...")
        logger.fault("Something really BAD happens!!")
        logger.debug("debug")
        logger.error("error\(flag)")

        Logger().warning("class-method")
    }
}
