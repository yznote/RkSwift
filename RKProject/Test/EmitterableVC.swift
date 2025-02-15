//
//  EmitterableVC.swift
//  RKProject
//
//  Created by yunbao02 on 2025/1/16.
//

import PinLayout
import UIKit

class EmitterableVC: RKBaseVC, Emitterable {
    // 大量的
    let startBtn = UIButton(type: .custom)
    let stopBtn = UIButton(type: .custom)
    // 单一的
    let minStartBtn = UIButton(type: .custom)
    let minStopBtn = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
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
          */

        /// 大量的
        btnSet(btn: startBtn, tit: "start", titCol: .hex("#ff0000"))
        startBtn.addTarget(self, action: #selector(clickStartBtn), for: .touchUpInside)
        view.addSubview(startBtn)

        btnSet(btn: stopBtn, tit: "stop", titCol: .hex("#fff000"))
        stopBtn.addTarget(self, action: #selector(clickStopBtn), for: .touchUpInside)
        view.addSubview(stopBtn)

        /// 逐一
        btnSet(btn: minStartBtn, tit: "min-start", titCol: .hex("#ff0000"))
        minStartBtn.addTarget(self, action: #selector(clickMinStartBtn), for: .touchUpInside)
        view.addSubview(minStartBtn)

        btnSet(btn: minStopBtn, tit: "min-stop", titCol: .hex("#fff000"))
        minStopBtn.addTarget(self, action: #selector(clickMinStopBtn), for: .touchUpInside)
        view.addSubview(minStopBtn)

        /// 初始化
        initEmitter()
        // 布局
        let point = CGPointMake(rkScreenWidth - 20, rkScreenHeight - 50)
        setOneByOne(point)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        startBtn.pin.right(to: view.edge.hCenter).marginRight(10).top(20%).sizeToFit()
        stopBtn.pin.after(of: startBtn, aligned: .center).marginLeft(10).sizeToFit()

        minStartBtn.pin.right(to: view.edge.hCenter).marginRight(10).below(of: stopBtn).marginTop(50).sizeToFit()
        minStopBtn.pin.after(of: minStartBtn, aligned: .center).marginLeft(10).sizeToFit()
    }

    //
    @objc func clickMinStartBtn() {
        touchShow()
    }

    @objc func clickMinStopBtn() {
        touchStop()
    }

    //
    @objc func clickStartBtn() {
        let point = CGPointMake(rkScreenWidth - 20, rkScreenHeight - 50)
        startEmittering(point)
    }

    @objc func clickStopBtn() {
        stopEmittering()
    }

    // uni
    func btnSet(btn: UIButton, tit: String, titCol: UIColor) {
        btn.setTitle(tit, for: .normal)
        btn.setTitleColor(titCol, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        btn.backgroundColor = .hex("#666", 0.3)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.layer.borderColor = titCol.cgColor
        btn.layer.borderWidth = 1
    }
}
