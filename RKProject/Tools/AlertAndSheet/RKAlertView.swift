//
//  RKAlertView.swift
//  RKProject
//
//  Created by YB007 on 2020/11/26.
//

import UIKit

enum RKAlertStyle {
    case alert
    case sheet
}

// 可自行扩展 并在 .alert 或者 .sheet 的 for 循环中实现扩展
enum RKActionStyle {
    case normal         //普通标题
    case cancel         //取消标题
    case confirm        //确认标题
}

typealias RKAlertActionHandler = ((_ action: RKAlertAction) -> Void)

class RKAlertAction: NSObject {
    
    var actionTitleStr: NSString?
    var actionStyle: RKActionStyle?
    var actionHadler: RKAlertActionHandler?
    
    convenience init(title: String, style:RKActionStyle, handler: @escaping(RKAlertActionHandler)){
        self.init()
        actionTitleStr = title as NSString
        actionStyle = style
        actionHadler = handler
    }
}

class RKAlertView: UIView {

    lazy var bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    lazy var alertMsgL: UILabel = {
        let label = UILabel()
        label.font = UIFont.rkFont(ofSize: 14)
        label.textColor = rkAlertContentCor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    lazy var alertTitleL: UILabel = {
        let label = UILabel()
        label.font = UIFont.rkFont(ofSize: 15)
        label.textColor = rkAlertTitleCor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var alertTitleStr: String?
    var alertMessageStr: String?
    var alertSuperView: UIView!         //父视图
    var alertStyle: RKAlertStyle?       //展示类型 alert/sheet
    var alertActions = [RKAlertAction]()
    
    /**
     * title: 标题
     * message: 内容
     * showView: 父视图、为空使用 window 作为父视图
     * style: alert【默认】、sheet
     */
    convenience init(title: String, message: String, showView: UIView, style: RKAlertStyle) {
        self.init()
        
        alertTitleStr = title
        alertMessageStr = message
        alertSuperView = showView
        alertStyle = style
    }
    
    convenience init(title: String, message: String, style: RKAlertStyle) {
        self.init()
        alertTitleStr = title
        alertMessageStr = message
        alertSuperView = UIApplication.shared.rkWindow!
        alertStyle = style
    }
    
    
    func addAction(action :RKAlertAction) {
        self.alertActions.append(action)
    }
    
    func show() {
        
        if alertActions.count <= 0 {
            rkShowHud(title: rkLocalized(key: "信息错误"))
            return
        }
        
        self.frame = alertSuperView.bounds
        self.backgroundColor = UIColor(hexString: "#000000",alpha: 0.3)
        alertSuperView.addSubview(self)
        
        self.addSubview(bgView)
        
        if alertStyle == .sheet {
            
            var lastViewSnp = bgView.snp.bottom
            var lastSpace:CGFloat = 0.0;
            //底部约束是从 取消 按钮上部开始还是从主屏幕的底部开始【也就是说 取消 功能和其他功能布局是否一个整体】
            var bottomViewSnp = self.snp.bottom
            var bottomSpace:CGFloat = rkTabBarSafeSpace
            var hasCancel = false
            
            //功能键
            for (index,action) in self.alertActions.enumerated() {
                let btn = UIButton.init(type: .custom)
                
                switch action.actionStyle {
                case .cancel:
                    btn.setTitleColor(UIColor(hexString: "#969696"), for: .normal)
                case .normal:
                    btn.setTitleColor(UIColor(hexString: "#323232"), for: .normal)
                case .confirm:
                    btn.setTitleColor(rkMainCor, for: .normal)
                default: break
                    
                }
                
                btn.setTitle(action.actionTitleStr as String?, for: .normal)
                btn.titleLabel?.font = UIFont.rkFont(ofSize: 15)
                btn.tag = 1000+index
                btn.backgroundColor = UIColor.clear
                btn.addTarget(self, action: #selector(clikcActionBtn), for: .touchUpInside)
                if action.actionStyle == .cancel {
                    btn.layer.cornerRadius = bgView.layer.cornerRadius
                    btn.layer.masksToBounds = true
                    btn.backgroundColor = .white
                    self.addSubview(btn)
                    btn.snp.makeConstraints({ (make) in
                        make.bottom.equalTo(self.snp.bottom).offset(-rkTabBarSafeSpace)
                        make.height.equalTo(rklayout(40))
                        make.centerX.equalToSuperview()
                        make.width.equalTo(alertSuperView).multipliedBy(0.9)
                    })
                    bottomViewSnp = btn.snp.top
                    bottomSpace = 15.0
                    hasCancel = true
                }else{
                    let curLayout = ((hasCancel == true && index == 1) ? bgView.snp.bottom : lastViewSnp)
                    bgView.addSubview(btn)
                    btn.snp.makeConstraints({ (make) in
                        make.bottom.equalTo(curLayout).offset(-lastSpace)
                        make.height.equalTo(rklayout(40))
                        make.centerX.equalToSuperview()
                        make.width.equalTo(alertSuperView).multipliedBy(0.9)
                    })
                    let lineL = UILabel()
                    lineL.backgroundColor = rkLineCor
                    bgView.addSubview(lineL)
                    lineL.snp.makeConstraints { (make) in
                        make.width.centerX.equalTo(bgView)
                        make.height.equalTo(0.5)
                        make.bottom.equalTo(btn.snp.bottom)
                    }
                    lastSpace = 1.0
                }
                lastViewSnp = btn.snp.top
            }
            
            //最后一个按钮顶部线
            let lastTopLine = UILabel()
            lastTopLine.backgroundColor = rkLineCor
            bgView.addSubview(lastTopLine)
            lastTopLine.snp.makeConstraints { (make) in
                make.width.centerX.equalTo(bgView)
                make.bottom.equalTo(lastViewSnp)
                make.height.equalTo(0.5)
            }
            
            //提示语
            if (!alertMessageStr!.isEmpty) {
                rkprint("msg not empty")
                alertMsgL.text = alertMessageStr
                bgView.addSubview(alertMsgL)
                alertMsgL.snp.makeConstraints { (make) in
                    make.bottom.equalTo(lastViewSnp).offset(-8)
                    make.width.equalTo(bgView.snp.width).multipliedBy(0.8)
                    make.centerX.equalTo(bgView)
                }
                lastViewSnp = alertMsgL.snp.top
            }
            //标题
            if (!alertTitleStr!.isEmpty) {
                rkprint("title not empty")
                alertTitleL.text = alertTitleStr
                bgView.addSubview(alertTitleL)
                alertTitleL.snp.makeConstraints { (make) in
                    make.centerX.equalTo(bgView)
                    make.bottom.equalTo(lastViewSnp).offset(-10)
                    make.height.equalTo(20)
                }
                lastViewSnp = alertTitleL.snp.top
            }

            var contentOrTitleTopSpace = 10
            if (alertTitleStr!.isEmpty) && (alertMessageStr!.isEmpty) {
                contentOrTitleTopSpace = 0
                lastTopLine.isHidden = true
            }
            bgView.snp.makeConstraints { (make) in
                make.bottom.equalTo(bottomViewSnp).offset(-bottomSpace)
                make.width.equalTo(alertSuperView).multipliedBy(0.9)
                make.centerX.equalTo(alertSuperView)
                make.top.equalTo(lastViewSnp).offset(-contentOrTitleTopSpace)
            }
        }
        else {
            let nums = Double(self.alertActions.count)
            var lastViewSnp = bgView.snp.bottom
            var hViewSnp = bgView.snp.left
            //按钮
            for (index,action) in self.alertActions.enumerated() {
                let btn = UIButton.init(type: .custom)
                
                switch action.actionStyle {
                case .cancel:
                    btn.setTitleColor(UIColor(hexString: "#969696"), for: .normal)
                case .normal:
                    btn.setTitleColor(UIColor(hexString: "#323232"), for: .normal)
                case .confirm:
                    btn.setTitleColor(rkMainCor, for: .normal)
                default: break
                    
                }
                
                btn.setTitle(action.actionTitleStr as String?, for: .normal)
                btn.titleLabel?.font = UIFont.rkFont(ofSize: 15)
                btn.tag = 1000+index
                btn.backgroundColor = UIColor.clear
                btn.addTarget(self, action: #selector(clikcActionBtn), for: .touchUpInside)
                bgView.addSubview(btn)
                btn.snp.makeConstraints { (make) in
                    make.width.equalTo(bgView.snp.width).multipliedBy(1.0/nums)
                    make.left.equalTo(hViewSnp)
                    make.height.equalTo(40)
                    make.bottom.equalTo(lastViewSnp)
                }
                if index > 0 {
                    let vLabel = UILabel()
                    vLabel.backgroundColor = rkLineCor
                    bgView.addSubview(vLabel)
                    vLabel.snp.makeConstraints { (make) in
                        make.right.equalTo(btn.snp.left)
                        make.centerY.equalTo(btn.snp.centerY)
                        make.width.equalTo(0.5)
                        make.height.equalTo(btn.snp.height).multipliedBy(0.8)
                    }
                }
                hViewSnp = btn.snp.right
                if (index+1) == Int(nums) {
                    lastViewSnp = btn.snp.top
                }
            }
            let hLabel = UILabel()
            hLabel.backgroundColor = rkLineCor
            bgView.addSubview(hLabel)
            hLabel.snp.makeConstraints { (make) in
                make.centerX.width.equalToSuperview()
                make.bottom.equalTo(lastViewSnp)
                make.height.equalTo(0.5)
            }
            lastViewSnp = hLabel.snp.top
            //内容
            if (!alertMessageStr!.isEmpty) {
                alertMsgL.text = alertMessageStr
                bgView.addSubview(alertMsgL)
                alertMsgL.snp.makeConstraints { (make) in
                    make.centerX.equalTo(bgView)
                    make.width.equalTo(bgView.snp.width).multipliedBy(0.8)
                    make.bottom.equalTo(lastViewSnp).offset(-10)
                }
                lastViewSnp = alertMsgL.snp.top
            }
            //标题
            if (!alertTitleStr!.isEmpty) {
                alertTitleL.text = alertTitleStr
                bgView.addSubview(alertTitleL)
                alertTitleL.snp.makeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.bottom.equalTo(lastViewSnp).offset(-10)
                    if !alertMessageStr!.isEmpty {
                        make.height.equalTo(20)
                    }
                }
                lastViewSnp = alertTitleL.snp.top
            }
            
            bgView.snp.makeConstraints { (make) in
                make.centerY.equalTo(alertSuperView.snp.centerY).multipliedBy(0.9)
                make.centerX.equalToSuperview()
                make.width.equalTo(alertSuperView.snp.width).multipliedBy(0.65)
                make.height.greaterThanOrEqualTo(bgView.snp.width).multipliedBy(0.5)
                make.top.equalTo(lastViewSnp).offset(-10)
            }
        }
    }
    
    @objc func clikcActionBtn(sender:UIButton){
        
        let action = self.alertActions[sender.tag-1000];
        if action.actionHadler != nil {
            action.actionHadler!(action)
        }
        self.subviews.forEach { (sub) in
            sub.removeFromSuperview()
        }
        self.removeFromSuperview()
        
    }


}
