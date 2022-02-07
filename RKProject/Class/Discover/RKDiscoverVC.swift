//
//  RKDiscoverVC.swift
//  RKProject
//
//  Created by YB007 on 2020/11/25.
//

import UIKit

class RKDiscoverVC: RKBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        leftItem.isHidden = true
        titleL.text = rkLocalized(key: "发现").appending(" Top")
    }
    

    
}
