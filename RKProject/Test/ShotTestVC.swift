//
//  ShotTestVC.swift
//  RKProject
//
//  Created by yunbao02 on 2024/12/26.
//

import PinLayout
import UIKit

class ShotTestVC: RKBaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()

        titleL.text = "截屏录屏"

        let showL = UILabel()
        showL.text = "这个是可以显示的内容"
        showL.textColor = .hex("#fff000")
        showL.backgroundColor = .hex("#000000", 0.5)
        view.addSubview(showL)
        showL.pin.top(15%).width(100).height(30).hCenter()

        let entryView = makeSecView()
        entryView.backgroundColor = .hex("#ff0000", 0.5)
        view.addSubview(entryView)
        entryView.pin.width(100%).hCenter().top(20%).height(200)

        let hideL = UILabel()
        hideL.text = "这个是不可以显示的内容"
        hideL.textColor = .hex("#ff0000")
        hideL.backgroundColor = .hex("#000000", 0.5)
        entryView.addSubview(hideL)
//        hideL.pin.top(20%).width(200).height(30).hCenter()
    }
}

// 不希望被录屏的内容添加到此view上即可
public func makeSecView() -> UIView {
    let field = UITextField()
    field.isSecureTextEntry = true
    guard let view = field.subviews.first else {
        return UIView()
    }
    view.subviews.forEach { $0.removeFromSuperview() }
    view.isUserInteractionEnabled = true
    return view
}
