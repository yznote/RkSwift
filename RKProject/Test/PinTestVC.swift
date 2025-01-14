//
//  PinTestVC.swift
//  RKProject
//
//  Created by yunbao02 on 2025/1/14.
//

import UIKit

class PinTestVC: RKBaseVC {
    private var mainView: PinTestView {
        return view as! PinTestView
    }

    override func loadView() {
        view = PinTestView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
