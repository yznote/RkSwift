//
//  RKMineCell.swift
//  RKProject
//
//  Created by YB007 on 2020/12/5.
//

import UIKit

class RKMineCell: RKBaseTableCell {

    
    lazy var leftIV: UIImageView = {
        let imgIV = UIImageView()
        imgIV.backgroundColor = .brown
        imgIV.layer.cornerRadius = 3;
        imgIV.layer.masksToBounds = true
        return imgIV
    }()
    
    lazy var contenL: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#323232")
        label.font = UIFont.rkFont(ofSize: 15)
        return label
    }()
    
    override func configCellUI() {
        addSubview(leftIV)
        leftIV.snp.makeConstraints { (make) in
            make.width.height.equalTo(rklayout(40))
            make.centerY.equalTo(self)
            make.left.equalTo(15)
        }
        addSubview(contenL)
        contenL.snp.makeConstraints { (make) in
            make.centerY.equalTo(leftIV)
            make.left.equalTo(leftIV.snp.right).offset(5)
        }
        
        rkCreateLine(edge: 15, superView: self)
        
    }
    
    var dataDic: Dictionary<String, Any>? {
        didSet{
            guard let dic = dataDic else { return }
            //leftIV
            contenL.text = dic["title"] as? String
        }
    }
    

}
