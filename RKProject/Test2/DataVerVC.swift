//
//  DataVerVC.swift
//  RKProject
//
//  Created by yunbao02 on 2025/5/21.
//

import UIKit

class DataVerVC: RKBaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()

        // data1()
        data2()
    }

    //
    func data2() {
        let dic = [
            12: "12",
            "key": "abc",
        ] as [AnyHashable: String]
        debug.log("是否字典：\(isDic(dic))")
        debug.log("是否数组：\(isArray(dic))")

        let list = [
            [
                12: "12",
                "key": "abc",
            ],
            [
                13: "12",
                "key1": "abc",
            ],
        ]
        debug.log("是否字典：\(isDic(list))")
        debug.log("是否数组：\(isArray(list))")
    }

    // 排序
    func data1() {
        let dic: [String: Any] = [
            "id": "10",
            "name": "zhang san",
            "account": [
                "phone": 123,
                "name": "li si",
                "b": "bbb",
                "a": "aaa",
            ],
            "skip": ["jump", "stand", "run", "d", "b", "a"],
            "lear": [
                ["id": "123", "name": "网名", "age": 10],
                ["id": "123", "nam": "网名", "age": 11],
                ["id": "123", "nam": "网名", "age": 9, "b": "b"],
                ["id": "123", "name": "网名", "age": 8, "a": "a"],
            ],
            "awm": NSNull(),
            "abc": NSNumber(value: true),
            "abc1": NSNumber(value: false),
        ]
        let sortStr = manualSort(rawDic: dic, deep: true)
        debug.log("real-sort:\n\(sortStr)")
    }
}
