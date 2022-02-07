//
//  RKBaseTableCell.swift
//  RKProject
//
//  Created by YB007 on 2020/12/5.
//

import UIKit

import Reusable
import Kingfisher

class RKBaseTableCell: UITableViewCell ,Reusable{

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = rkContentCor
        configCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configCellUI(){ }

}
