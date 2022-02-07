//
//  RKPackage.swift
//  RKProject
//
//  Created by YB007 on 2020/12/1.
//

import Foundation

import UIKit
import MBProgressHUD
import MJRefresh
import Kingfisher

// MARK: -
// MARK: - Kingfisher
extension ImageView {
    @discardableResult
    public func rksetImage(urlString: String?, placeholder: Placeholder? = UIImage(named: "1")) -> RetrieveImageTask {
        return self.kf.setImage(with: URL(string: urlString ?? ""), placeholder: placeholder,options: [.transition(.fade(0.5))])
    }
}
extension UIButton {
    @discardableResult
    public func rksetImage(urlString: String?, for state: UIControl.State, placeholder: UIImage? = UIImage(named: "1")) -> RetrieveImageTask{
        return self.kf.setImage(with: URL(string: urlString ?? ""), for: state, placeholder: placeholder, options: [.transition(.fade(0.5))])
    }
}
/*
extension Kingfisher where Base: ImageView {
    @discardableResult
    public func setImage(urlString: String?, placeholder: Placeholder? = UIImage(named: "1")) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? ""), placeholder: placeholder,options: [.transition(.fade(0.5))])
    }
}
extension Kingfisher where Base: UIButton {
    @discardableResult
    public func setImage(urlString: String?, for state: UIControl.State, placeholder: UIImage? = UIImage(named: "1")) -> RetrieveImageTask{
        return setImage(with: URL(string: urlString ?? ""), for: state, placeholder: placeholder, options: [.transition(.fade(0.5))])
    }
}
*/
// MARK: -
// MARK: - 提示框自定义
//展示普通文本
func rkShowHud(title:String){
    let hud = MBProgressHUD.showAdded(to: UIApplication.shared.rkWindow!, animated: true)
    hud.label.text = title as String
    hud.label.font = UIFont.rkFont(ofSize: 15)
    hud.label.numberOfLines = 0
    hud.contentColor = .white
    hud.bezelView.backgroundColor = .black
    hud.bezelView.alpha = 1
    hud.bezelView.style = .blur
    hud.bezelView.blurEffectStyle = .dark
    hud.mode = .customView
    hud.removeFromSuperViewOnHide = true
    hud.hide(animated: false, afterDelay: 1.5)
}
//加载中
func rkLoadingHud() {
    rkLoadingHud(title: "")
}
func rkLoadingHud(title: String) {
    rkHideHud()
    let hud = MBProgressHUD.showAdded(to: UIApplication.shared.rkWindow!, animated: true)
    hud.label.text = title as String
    hud.label.font = UIFont.rkFont(ofSize: 13)
    hud.label.numberOfLines = 0
    hud.contentColor = .white
    hud.bezelView.backgroundColor = .black
    hud.bezelView.alpha = 1
    hud.bezelView.style = .blur
    hud.bezelView.blurEffectStyle = .dark
}
//隐藏
func rkHideHud() {
    MBProgressHUD.hide(for: UIApplication.shared.rkWindow!, animated: false)
}

// MARK: -
// MARK: - 刷新控件自定义
extension UIScrollView {
    var rkHead: MJRefreshHeader {
        get { return mj_header! }
        set { mj_header = newValue }
    }
    var rkFoot: MJRefreshFooter {
        get { return mj_footer! }
        set { mj_footer = newValue }
    }
}
class RkRefreshHeader: MJRefreshGifHeader {
    override func prepare() {
        super.prepare()
        /*
        setImages([UIImage(named: "refresh_normal")!], for: .idle)
        setImages([UIImage(named: "refresh_will_refresh")!], for: .pulling)
        setImages([UIImage(named: "refresh_loading_1")!,
                   UIImage(named: "refresh_loading_2")!,
                   UIImage(named: "refresh_loading_3")!], for: .refreshing)
        */
        lastUpdatedTimeLabel?.isHidden = false
        stateLabel?.isHidden = false
    }
}

class RkRefreshAutoHeader: MJRefreshHeader {}

class RkRefreshFooter: MJRefreshBackNormalFooter {}

class RkRefreshAutoFooter: MJRefreshAutoFooter {}

class RkRefreshDiscoverFooter: MJRefreshBackGifFooter {
    override func prepare() {
        super.prepare()
        backgroundColor = rkBackGroundCor
        setImages([UIImage(named: "refresh_discover")!], for: .idle)
        stateLabel?.isHidden = true
        refreshingBlock = { self.endRefreshing() }
    }
}
class RkRefreshTipKissFooter: MJRefreshBackFooter {
    lazy var tipLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.textColor = UIColor.lightGray
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.numberOfLines = 0
        return tl
    }()
    lazy var imageView: UIImageView = {
        let iw = UIImageView()
        iw.image = UIImage(named: "refresh_kiss")
        return iw
    }()
    override func prepare() {
        super.prepare()
        backgroundColor = rkBackGroundCor
        mj_h = 240
        addSubview(tipLabel)
        addSubview(imageView)
    }
    override func placeSubviews() {
        tipLabel.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 60)
        imageView.frame = CGRect(x: (bounds.width - 80 ) / 2, y: 110, width: 80, height: 80)
    }
    convenience init(with tip: String) {
        self.init()
        refreshingBlock = { self.endRefreshing() }
        tipLabel.text = tip
    }
}




