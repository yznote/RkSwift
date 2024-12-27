//
//  ShotTestV.swift
//  RKProject
//
//  Created by yunbao02 on 2024/12/26.
//

import FlexLayout
import PinLayout
import UIKit

class ShotTestVC: RKBaseVC {
    var rootView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()

        titleL.text = "截屏录屏"

        view.addSubview(rootView)

        let showL = UILabel()
        showL.text = "这个是可以显示的内容"
        showL.textColor = .hex("#fff000")
        showL.backgroundColor = .hex("#000000", 0.5)
        // view.addSubview(showL)
        // showL.pin.top(15%).width(100).height(30).hCenter()

        let entryView = makeSecView()
        entryView.backgroundColor = .hex("#ff0000", 0.5)
        // view.addSubview(entryView)
        // entryView.pin.width(100%).hCenter().top(20%).height(200)

        let hideL = UILabel()
        hideL.text = "这个是不可以显示的内容"
        hideL.textColor = .hex("#ff0000")
        hideL.backgroundColor = .hex("#000000", 0.5)
        // entryView.addSubview(hideL)
        // hideL.pin.top(20%).width(200).height(30).hCenter()

        rootView.flex.backgroundColor(.hex("#ff0000", 0.3)).define { flex in
            // 可见
            flex.addItem(showL).marginTop(20).left(10).backgroundColor(.hex("#fff000", 0.5))
            // 不可见
            flex.addItem(entryView).width(100%).marginTop(20).alignItems(.center).backgroundColor(.hex("#0000ff", 0.3)).define { flex in
                flex.addItem(hideL)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        rootView.pin.top(rkNaviHeight + 5).left().right() // .bottom(safeBot)
        rootView.flex.layout(mode: .adjustHeight)
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
