//
//  EmitterableVC.swift
//  RKProject
//
//  Created by yunbao02 on 2025/1/16.
//

import PinLayout
import UIKit

class EmitterableVC: RKBaseVC, Emitterable {
    let startBtn = UIButton(type: .custom)
    let stopBtn = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()

        startBtn.setTitle("start", for: .normal)
        startBtn.setTitleColor(.hex("#ff0000"), for: .normal)
        startBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        startBtn.addTarget(self, action: #selector(clickStartBtn), for: .touchUpInside)
        startBtn.backgroundColor = .hex("#666", 0.3)
        startBtn.layer.cornerRadius = 3
        startBtn.layer.masksToBounds = true
        startBtn.layer.borderColor = UIColor.hex("#ff0000").cgColor
        startBtn.layer.borderWidth = 1
        view.addSubview(startBtn)

        stopBtn.setTitle("stop", for: .normal)
        stopBtn.setTitleColor(.hex("#fff000"), for: .normal)
        stopBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        stopBtn.addTarget(self, action: #selector(clickStopBtn), for: .touchUpInside)
        stopBtn.backgroundColor = .hex("#666", 0.3)
        stopBtn.layer.cornerRadius = 3
        stopBtn.layer.masksToBounds = true
        stopBtn.layer.borderColor = UIColor.hex("#fff000").cgColor
        stopBtn.layer.borderWidth = 1
        view.addSubview(stopBtn)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        startBtn.pin.right(to: view.edge.hCenter).marginRight(10).top(20%).sizeToFit()
        stopBtn.pin.after(of: startBtn, aligned: .center).marginLeft(10).sizeToFit()
    }

    @objc func clickStartBtn() {
        let point = CGPointMake(rkScreenWidth - 20, rkScreenHeight - 50)
        startEmittering(point)
    }

    @objc func clickStopBtn() {
        stopEmittering()
    }
}
