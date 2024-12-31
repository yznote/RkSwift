import FlexLayout
import PinLayout
import SwifterSwift
import SwiftyJSON
import Then
import UIKit

class SwiftyJsonVC: RKBaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()

        // jsonTest()
        // pinTest()
        // swifterTest()
        // testThen()
        // testGcd()
        testType()
    }

    /// 类型判断
    func testType() {
        let array = [1, 2, 3]
        debug.log("is-array:\(isArray(array))")
        let dic: [String: Any] = ["id": 1, "name": "zhangsan"]

        test(array)
        test(dic)

        //
        func test(_ testType: Any) {
            if testType is [String: Any] {
                debug.log("is dic")
            } else {
                debug.log("isn't dic")
            }
        }
    }

    /// GCD
    func testGcd() {
        let group = DispatchGroup()
        let queue = DispatchQueue.global()

        group.enter()
        queue.async(group: group) {
            debug.log("Task 1 started")
            sleep(2) // 模拟任务执行时间
            debug.log("Task 1 finished")
            group.leave()
        }
        group.enter()
        queue.async(group: group) {
            debug.log("Task 2 started")

            sleep(1) // 模拟任务执行时间
            debug.log("Task 2 finished")
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) {
            debug.log("All tasks are completed")
        }
    }

    func testGcd2() {
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        let semaphore = DispatchSemaphore(value: 0)

        queue.async(group: group) {
            debug.log("Task 1 started")
            sleep(2) // 模拟任务执行时间
            debug.log("Task 1 finished")
            semaphore.signal()
        }

        queue.async(group: group) {
            debug.log("Task 2 started")
            sleep(1) // 模拟任务执行时间
            debug.log("Task 2 finished")
            semaphore.signal()
        }

        group.notify(queue: DispatchQueue.main) {
            debug.log("All tasks are completed")
            // 释放信号量、与oc有区别
            for _ in 0..<2 {
                semaphore.wait()
            }
        }
    }

    /// then
    func testThen() {
        let _ = UILabel().then { a in
            a.text = "abc"
        }

        UserDefaults.standard.do { u in
            u.set("123", forKey: "key")
            u.synchronize()
        }
    }

    /// swifterswift
    func swifterTest() {
        // let str1:String = ""
        // let str2:String = "   "

        // dic
        // let dic: [String:Any] = ["id":1,"name":"小明"]
        // let res = dic.has(key: "id")
        // print("===res:\(res)")

        //
        // let lab = UILabel()
        // lab.font = lab.font.italic;

        // var tab = UITableView()
        // tab.register(cellWithClass: RKBaseTableCell.self)

        // 时间戳
        // let timestamp = Date().unixTimestamp
        // print("===>time1:\(timestamp)")
        // let intTime = Int(timestamp*1000)
        // print("===>time2:\(intTime)")
    }

    /// swiftyjson
    func jsonTest() {
        let dic: [String: Any] = [
            "action": "1",
            "uid": "123",
        ]
        let newDic = JSON(dic)

        let action = newDic["action"].stringValue
        if action == "1" {
            print("enter-:\(action)")
        } else {
            print("enter-else:\(action)")
        }

        // 判空
        let oeStr = newDic["uid"].stringValue
        if oeStr.isEmpty {
            rkprint("===>为空\(newDic)")
        } else {
            rkprint("===>不为空\(JSON(newDic))")
        }

        let array: [Any] = [
            ["uid": 1234, "name": "na", "age": 13],
            ["uid": 123, "name": "na", "age": 13],
        ]
        rkprint(array)
        rkprint("====>", array)
        rkprint("====>", JSON(array))
        debug.log("debug:", newDic)

        let idx = array.firstIndex(
            // where: {($0 as! [String:Any])["uid"] as! Int == 123
            where: { JSON($0)["uid"].intValue == 1235
            }
        )
        debug.log("array-idx:\(idx ?? -10)")
    }

    /// pin
    func pinTest() {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .hex("#fff000")
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        view.addSubview(btn)
        btn.pin.width(60).height(20).bottom(10%).hCenter()

        print("===>running")

        let btn2 = UIButton()
        btn2.backgroundColor = .hex("000000")
        view.addSubview(btn2)
        // btn2.pin.width(of: btn).height(of: btn).left(of: btn, aligned: .center) // 在左边
        // btn2.pin.width(of: btn).height(of: btn).before(of: btn,aligned: .center) // 左

        // btn2.pin.width(of: btn).height(of: btn).right(of: btn,aligned: .center) // 在右边
        // btn2.pin.width(of: btn).height(of: btn).after(of: btn,aligned: .center)

        // btn2.pin.width(of: btn).height(of: btn).below(of: btn, aligned: .center) // 在下面
        btn2.pin.width(of: btn).height(of: btn).above(of: btn, aligned: .center) // 上
    }

    @objc func clickBtn() {
        print("===>log")
    }
}
