//
//  DataVerVC.swift
//  RKProject
//
//  Created by yunbao02 on 2025/5/21.
//

import ActiveLabel
import UIKit

class DataVerVC: RKBaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()

        // data1()
        // data2()
        // active1()
        active2()
    }

    // label custom
    func active2() {
        var regular = "\\sabc\\b"
        regular = "abc"

        let customType = ActiveType.custom(pattern: regular)
        let label = ActiveLabel()
        label.numberOfLines = 0
        label.enabledTypes = [.mention, .hashtag, .url, customType]
        label.text = "This is a post with abc #hashtags and a fix @userhandle. abcdef"
        label.textColor = .black
        label.customColor = [customType: .hex("#ff0000")]
        label.handleCustomTap(for: customType) { custom in
            debug.log("custom=>\(custom)")
        }
        label.backgroundColor = .hex("#fff000", 0.3)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(naviView.snp.bottom).offset(15)
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view.snp.right).offset(-15)
        }
    }

    // label nor
    func active1() {
        let label = ActiveLabel()
        label.numberOfLines = 0
        label.enabledTypes = [.mention, .hashtag, .url]
        label.text = "This is a post with #hashtags and a fix @userhandle. http://www.  https://www.baidu.com"
        label.textColor = .black
        label.mentionColor = .hex("#ff0000")
        label.URLColor = .hex("#969696")
        label.handleHashtagTap { hastag in
            debug.log("hastag=>\(hastag)")
        }
        label.handleURLTap { url in
            debug.log("url=>\(url)")
        }
        label.handleMentionTap { mention in
            debug.log("mention=>\(mention)")
        }
        label.backgroundColor = .hex("#fff000", 0.3)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(naviView.snp.bottom).offset(15)
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view.snp.right).offset(-15)
        }
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
