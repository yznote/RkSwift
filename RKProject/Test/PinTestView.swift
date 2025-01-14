//
//  PinTestView.swift
//  RKProject
//
//  Created by yunbao02 on 2025/1/14.
//

import PinLayout
import UIKit

class PinTestView: UIView {
    /// property
    let container = UIView()
    let iconIV = UIImageView(image: UIImage(named: "test"))
    let desL = UILabel()
    let submitBtn = UIButton()

    init() {
        super.init(frame: .zero)

        container.backgroundColor = .hex("#fff000", 0.2)
        addSubview(container)

        iconIV.contentMode = .scaleAspectFill
        iconIV.backgroundColor = .hex("#ff0000")
        container.addSubview(iconIV)
        configLabel(
            desL,
            "this is a label, there are some on on description of css.this is a label, there are some on on description of css.this is a label, there are some on on description of css.this is a label, there are some on on description of css.this is a label, there are some on on description of css."
        )
        container.addSubview(desL)

        submitBtn.setTitle("btn", for: .normal)
        submitBtn.setTitleColor(.hex("#666"), for: .normal)
        submitBtn.backgroundColor = .hex("#eee")
        submitBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        addSubview(submitBtn)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        container.pin.width(80%).top(pin.safeArea + rkNaviHeight).horizontally().justify(.center)

        iconIV.pin.left().width(100).aspectRatio()
        desL.pin.after(of: iconIV, aligned: .center).marginLeft(10).right().sizeToFit(.width)
        //
        container.pin.wrapContent(.all, padding: 10)

        submitBtn.pin.below(of: container, aligned: .center).marginTop(10).sizeToFit()
    }

    /// lab
    func configLabel(_ label: UILabel, _ txt: String) {
        label.text = txt
        label.textColor = .hex("#ccc")
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
    }
}
