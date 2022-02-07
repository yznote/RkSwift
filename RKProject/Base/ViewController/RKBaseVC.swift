//
//  RKBaseVC.swift
//  RKProject
//
//  Created by YB007 on 2020/11/21.
//

import UIKit

import SnapKit

class RKBaseVC: UIViewController {

    lazy var naviView = UIView()
    lazy var naviSubView = UIView()
    lazy var leftItem = UIButton()
    lazy var rightItem = UIButton()
    lazy var titleL = UILabel()
    lazy var naviLineL = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        createBaseNavi()
        
    }
    
    func createBaseNavi() {
        
        view.backgroundColor = rkBackGroundCor
        
        naviView.backgroundColor = UIColor.clear
        naviView.frame = CGRect(x: 0, y: 0, width: rkScreenWidth, height: rkNaviHeight)
        view.addSubview(naviView)
        
        naviSubView.backgroundColor = rkNaviBgCor
        naviSubView.frame = naviView.bounds
        naviView.addSubview(naviSubView)
        
        titleL.textColor = rkNaviTitleCor
        titleL.font = rkNaviTitleFont
        naviSubView.addSubview(titleL)
        titleL.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
            make.centerX.equalTo(naviSubView)
            make.width.lessThanOrEqualTo(naviSubView.snp.width).multipliedBy(0.8)
        }
        
        leftItem.setImage(UIImage(named: "导航-返回"), for: .normal)
        leftItem.setTitleColor(rkNaviItemCor, for: .normal)
        leftItem.titleLabel?.font = rkNaviItemFont
        leftItem.tintColor = .gray
        leftItem.addTarget(self, action: #selector(clickNaviLeftBtn), for: .touchUpInside)
        naviSubView.addSubview(leftItem)
        leftItem.snp.makeConstraints { (make) in
            make.left.equalTo(naviSubView.snp.left).offset(0)
            make.width.height.equalTo(rklayout(40))
            make.centerY.equalTo(titleL)
        }
        
        rightItem.titleLabel?.font = rkNaviItemFont
        rightItem.setTitleColor(rkNaviItemCor, for: .normal)
        rightItem.titleLabel?.font = rkNaviItemFont
        rightItem.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        rightItem.addTarget(self, action: #selector(clickNaviRightBtn), for: .touchUpInside)
        naviSubView .addSubview(rightItem)
        rightItem.snp.makeConstraints { (make) in
            make.right.equalTo(naviSubView.snp.right).offset(-3)
            make.centerY.equalTo(titleL)
        }
        rightItem.isHidden = true
        
        naviLineL = rkGetLine(edge: 0, superView: naviSubView)
        
    }

    @objc func clickNaviLeftBtn() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @objc func clickNaviRightBtn() {
        
        
        
    }

}
