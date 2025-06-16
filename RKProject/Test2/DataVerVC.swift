//
//  DataVerVC.swift
//  RKProject
//
//  Created by yunbao02 on 2025/5/21.
//

import ActiveLabel
import JKCategories
import Nantes
import SwiftyJSON
import UIKit

class DataVerVC: RKBaseVC, NantesLabelDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        // data1()
        // data2()
        // active1()
        // active2()
        // active3()
        // data3()
        attribute()
    }

    // 文本链接自识别
    func attribute() {
        let linkLabel: NantesLabel = .init(frame: .zero)
        linkLabel.delegate = self

        linkLabel.linkAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.hex("#969696"),
            NSAttributedString.Key.backgroundColor: UIColor.hex("#fff"),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
        ]

        linkLabel.enabledTextCheckingTypes = [.link, .address, .phoneNumber]
        linkLabel.numberOfLines = 0
        linkLabel.lineSpacing = 2
        linkLabel.verticalAlignment = .top
        linkLabel.linkBackgroundEdgeInset = UIEdgeInsets(top: 0, left: -3, bottom: 2, right: -3)

        linkLabel.text = "你好这是一个链接13100000000你好这是一个链接你好这是一个链接你好这是 #abc @name  一个链接你好这是一个链接你好这是一个链接你好这是一个链接你好这是一个链接你好这是一个链接你好这是一个链接https://www.instacart.com #ok 泰安市岱岳区100号"

        view.addSubview(linkLabel)
        linkLabel.snp.makeConstraints { make in
            make.top.equalTo(naviView.snp.bottom).offset(15)
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view.snp.right).offset(-15)
        }
    }

    // NantesLabelDelegate
    func attributedLabel(_ label: NantesLabel, didSelectLink link: URL) {
        debug.log("link====>\(link)")
        UIApplication.shared.open(link)
    }

    //
    func data3() {
        let jsonDic = JSON(parseJSON: jsonString)
        debug.log("====>\(jsonDic.type)")
        // print("okk:\(jsonDic)")

        var email = jsonDic["contact"]["email"].stringValue
        debug.log("raw-emial1:\(email)")
        email.urlEncode()
        debug.log("raw-emial2:\(email)")

        var url = jsonDic["url"].stringValue
        debug.log("raw-url1:\(url)")
        url.urlEncode()
        debug.log("raw-url2:\(url)")
        debug.log("==>", url.urlDecode(), url.urlEncode())
    }

    func active3() {
        // 正则匹配 url
        let regular = "((https?://|www\\.|pic\\.)[-\\w;/?:@&=+$\\|\\_.!~*\\|'()\\[\\]%#,☺]+[\\w/#](\\(\\))?)" + "(?=$|[\\s',\\|\\(\\).:;?\\-\\[\\]>\\)])"

        let customType = ActiveType.custom(pattern: regular)
        let label = ActiveLabel()

        // 使用段落样式模拟左右内边距
        let padding = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = padding.left
        paragraphStyle.headIndent = padding.left
        paragraphStyle.tailIndent = -padding.right
        paragraphStyle.paragraphSpacingBefore = 5
        paragraphStyle.paragraphSpacing = 5

        // 添加下划线【注意有顺序要求，尽可能往前放】
        label.configureLinkAttribute = { activeType, activeAtt, activeSel in
            // debug.log("===>config1:\(activeAtt)")
            var atts = activeAtt
            if activeType == customType {
                atts[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
                atts[NSAttributedString.Key.backgroundColor] = UIColor.hex("#ff0000", 0.2)
                // 基线偏移模拟上下边距
                atts[NSAttributedString.Key.baselineOffset] = padding.top
                // 段落模拟左右边距【在开头有效果，在句中无效果】
                // atts[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            }
            // debug.log("===>config2:\(atts)")
            return atts
        }

        label.numberOfLines = 0
        label.enabledTypes = [customType]
        label.text = "http://www.baidu.com 是 This is a post with abc #hashtags and a fix @userhandle. abcdef你好好好好好\u{2003}http://www.baidu.com #123"
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
        // url 需要以空格开头
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
