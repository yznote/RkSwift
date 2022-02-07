//
//  RKSetVC.swift
//  RKProject
//
//  Created by YB007 on 2020/12/5.
//

import UIKit

class RKSetVC: RKBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        titleL.text = rkLocalized(key: "设置")
        
        let strL = "当前语言:".appendingFormat("%@", rkLanguageType())
        
        let languageBtn = UIButton()
        languageBtn.backgroundColor = .red
        languageBtn.setTitle(strL, for: .normal)
        languageBtn.titleLabel?.font = UIFont.rkFont(ofSize: 15)
        languageBtn.layer.cornerRadius = 3
        languageBtn.layer.masksToBounds = true
        languageBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        languageBtn.addTarget(self, action: #selector(clikcChangeLanguage), for: .touchUpInside)
        view.addSubview(languageBtn)
        languageBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(naviView.snp.bottom).offset(60)
            make.height.equalTo(rklayout(50))
        }
        
    }
    
    @objc func clikcChangeLanguage(){
        rkSwitchLanguage()
    }
    
    override func clickNaviLeftBtn() {
        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    

}
