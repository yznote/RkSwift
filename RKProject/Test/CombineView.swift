//
//  CombineView.swift
//  RKProject
//
//  Created by yunbao02 on 2025/1/24.
//

import Combine
import FlexLayout
import UIKit

class CombineView: UIView {
    var containerView = UIView()

    var phoneTF = UITextField()
    var pwdTF = UITextField()
    var sendBtn = UIButton(type: .custom)
    var agreeSt = UISwitch()
    var loginBtn = UIButton()

    @Published var phoneVal: String? = ""
    @Published var pwdVal: String? = ""
    @Published var isAgree = false

    // 校验手机号的发布者
    var phoneVer: AnyPublisher<Bool, Never> {
        $phoneVal
            // 这里简单判断手机号长度
            .map { $0?.count == 11 ?true : false }
            .eraseToAnyPublisher()
    }

    // 校验验证码的发布者
    var pwdVer: AnyPublisher<Bool, Never> {
        $pwdVal
            .map { code in
                // 验证码校验逻辑（实际情况按照需求自定义）
                guard let code = code, // 值不能为nil
                      code.count == 4, // 长度为4
                      let _ = Int(code) // 能转为Int
                else { return false } // 以上三种全部满足返回true，否则返回false
                return true
            }
            .eraseToAnyPublisher() // 抹去类型转为AnyPublisher
    }

    var subscription = Set<AnyCancellable>()

    init() {
        super.init(frame: CGRectZero)

        setGradientColor()

        let tipsL = UILabel()
        tipsL.font = .boldSystemFont(ofSize: 20)
        tipsL.textColor = .hex("#fff")
        tipsL.text = "Welcome use flex and combine"

        setInput(tf: phoneTF, place: "input num")
        phoneTF.addTarget(self, action: #selector(phoneValChange), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(tfValChange), name: UITextField.textDidChangeNotification, object: nil)
        setInput(tf: pwdTF, place: "input pwd")
        pwdTF.addTarget(self, action: #selector(pwdValChange), for: .editingChanged)

        setBtn(btn: sendBtn, tit: "send code")
        sendBtn.addTarget(self, action: #selector(clickSend), for: .touchUpInside)
        setBtn(btn: loginBtn, tit: "to login")
        loginBtn.addTarget(self, action: #selector(clickLogin), for: .touchUpInside)

        agreeSt.addTarget(self, action: #selector(stValChange), for: .valueChanged)
        let protocolL = UILabel()
        protocolL.text = "this is a peace of protocol"
        protocolL.font = .systemFont(ofSize: 13)
        protocolL.textColor = .hex("#fff")

        /// UI
        let itemHeight: CGFloat = 50
        let itemMT: CGFloat = 20
        containerView.flex.paddingHorizontal(16).define { flex in
            flex.addItem().marginTop(50).alignItems(.center).define { flex in
                flex.addItem(tipsL)
            }

            flex.addItem().marginTop(itemMT).backgroundColor(.hex("#fff")).cornerRadius(itemHeight / 2).define { flex in
                flex.addItem(phoneTF).marginHorizontal(15).height(itemHeight)
            }

            flex.addItem().marginTop(itemMT).direction(.row).alignItems(.center).backgroundColor(.hex("#fff")).cornerRadius(itemHeight / 2).define { flex in
                flex.view?.layer.masksToBounds = true
                flex.addItem(pwdTF).marginHorizontal(15).height(itemHeight).grow(1)
                flex.addItem(sendBtn).minWidth(30%).height(itemHeight).right(0).backgroundColor(.hex("fff000", 0.3))
            }

            flex.addItem().marginTop(itemMT).direction(.row).alignItems(.center).define { flex in
                flex.addItem(agreeSt)
                flex.addItem(protocolL).marginLeft(10)
            }

            flex.addItem().marginTop(itemMT * 2).define { flex in
                flex.addItem(loginBtn).height(itemHeight).backgroundColor(.hex("#fff")).cornerRadius(itemHeight / 2)
            }
        }
        addSubview(containerView)

        /// combine
        phoneVer
            .receive(on: RunLoop.main)
            // .print("phoneChange")
            .assign(to: \.isEnabled, on: sendBtn)
            .store(in: &subscription)
        // 融合三个发布者
        Publishers.CombineLatest3(phoneVer, pwdVer, $isAgree)
            // .print("three-condation")
            .map { $0 && $1 && $2 } // 筛选逻辑
            .receive(on: RunLoop.main) // 在主线程接受
            .assign(to: \.isEnabled, on: loginBtn) // 结果分配
            .store(in: &subscription) // 返回值Cancellable对象储存在全局容器中
    }

    // 通知测试-和 phoneValChange、pwdValChange 雷同
    @objc func tfValChange(noti: Notification) {
        let notiTF = noti.object as? UITextField
        if let tf = notiTF, tf == phoneTF {
            debug.log("textfiled-phone:", tf)
        }
        if let tf = notiTF, tf == pwdTF {
            debug.log("textfiled-pwd:", tf)
        }
    }

    @objc func stValChange(st: UISwitch) {
        isAgree = st.isOn
    }

    @objc func phoneValChange(tf: UITextField) {
        phoneVal = tf.text
    }

    @objc func pwdValChange(tf: UITextField) {
        pwdVal = tf.text
    }

    @objc func clickSend() {
        rkShowHud(title: "send to \(phoneTF.text ?? "nothing")")
    }

    @objc func clickLogin() {
        rkShowHud(title: "login sucess")

        let dic: [String: Any] = [
            "action": "1",
            "uid": "123",
        ]
        let array: [Any] = [
            ["uid": 1234, "name": "na", "age": 13],
            ["uid": 123, "name": "na", "age": 13],
        ]
        debug.log("test1", dic)
        debug.log("test2", array)
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layout()
    }

    func layout() {
        containerView.pin.top(rkNaviHeight).left().right().bottom()
        containerView.flex.layout(mode: .adjustHeight)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout()
        return containerView.frame.size
    }

    func setBtn(btn: UIButton, tit: String) {
        btn.setTitle(tit, for: .normal)
        btn.setTitleColor(.hex("#323232"), for: .normal)
        btn.setTitleColor(.hex("#969696"), for: .disabled)
        btn.titleLabel?.font = .systemFont(ofSize: 13)
    }

    func setInput(tf: UITextField, place: String) {
        tf.placeholder = place
        tf.textColor = .hex("323232")
        tf.font = .systemFont(ofSize: 16)
        tf.keyboardType = .numberPad
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    // RGB Color: 184 220 200 -> 53 110 136
    func setGradientColor(colors: [CGColor] = [
        UIColor(red: 184 / 255.0, green: 220 / 255.0, blue: 200 / 255.0, alpha: 1.0).cgColor,
        UIColor(red: 53 / 255.0, green: 110 / 255.0, blue: 136 / 255.0, alpha: 1.0).cgColor,
    ]) {
        let layer = CAGradientLayer()
        layer.colors = colors
        layer.frame = UIScreen.main.bounds
        layer.startPoint = CGPoint(x: 0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.addSublayer(layer)
    }
}
