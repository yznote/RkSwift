//
//  RKMessageCell.swift
//  RKProject
//
//  Created by YB007 on 2020/12/26.
//

import UIKit

class RKMessageCell: RKBaseTableCell {

    lazy var leftIV: UIImageView = {
        let imgIV = UIImageView()
        imgIV.backgroundColor = .brown
        imgIV.layer.cornerRadius = 3;
        imgIV.layer.masksToBounds = true
        imgIV.contentMode = .scaleAspectFill
        return imgIV
    }()
    lazy var contentBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor(hexString: "#f5f5f5"), for: .normal)
        btn.titleLabel?.font = UIFont.rkFont(ofSize: 15)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.clipsToBounds = true
        return btn
    }()
    
    override func configCellUI() {
        
        addSubview(leftIV)
        leftIV.snp.makeConstraints { (make) in
            make.height.equalTo(self).multipliedBy(0.9)
            make.width.equalTo(leftIV.snp.height)
            make.centerY.equalTo(self)
            make.left.equalTo(15)
        }
        addSubview(contentBtn)
        contentBtn.snp.makeConstraints { (make) in
            make.left.equalTo(leftIV.snp.right).offset(10)
            make.centerY.equalTo(self)
            make.width.height.equalTo(rklayout(80))
        }
        
    }
    
}
