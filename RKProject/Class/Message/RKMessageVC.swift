//
//  RKMessageVC.swift
//  RKProject
//
//  Created by YB007 on 2020/11/25.
//

import UIKit

//import Kingfisher

class RKMessageVC: RKBaseVC {

    private var homeModel = HomeConfigModel()
    
    private lazy var dataArray: Array = {
        return [["icon":"https://cover.u17i.com/2020/09/2536927_1599117441_9e3CDdUKvtJe.sbig.jpg"]]
    }()
    private lazy var listTableView: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.backgroundColor = rkBackGroundCor
        tab.separatorStyle = .none
        tab.estimatedSectionHeaderHeight = 0
        tab.estimatedSectionFooterHeight = 0
        tab.register(cellType: RKMessageCell.self)
        tab.rkHead = RkRefreshHeader { [weak self] in
            self?.refreshTbale()
        }
        tab.rkFoot = RkRefreshTipKissFooter {[weak self] in
            self?.refreshTbale()
        }
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftItem.isHidden = true
        titleL.text = rkLocalized(key: "消息").appending(" Top")
        
        rightItem.isHidden = false
        rightItem.setTitle(rkLocalized(key: "配置"), for: .normal)
        
        self.view.addSubview(listTableView)
        if #available(iOS 11.0, *) {
            listTableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        listTableView.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(self.view)
            make.top.equalTo(self.naviView.snp.bottom)
            make.bottom.equalTo(self.view.snp.bottom).offset(-rkTabBarHeight)
        }
        listTableView.reloadData()
        
    }
    override func clickNaviRightBtn() {
        RKNetwork.rkloadData(target: RKHomeApi.homeConfig, model: HomeConfigData.self, showHud: true) { [self] (returnData, jsonData) in
            guard let info = returnData?.info , info.count > 0 else {
                rkShowHud(title: rkLocalized(key: "信息错误"))
                return
            }
            self.homeModel = info[0]
            rkprint("home:\(self.homeModel.login_type?[0] ?? "-1")")
            rkprint("guid:\(self.homeModel.guide?.switch ?? "-1")")
        } failure: { (stateCode, msg) in

        }

    }
    
    func refreshTbale() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
            self?.listTableView.rkHead.endRefreshing()
            self?.listTableView.rkFoot.endRefreshing()
        }
    }
    
}
extension RKMessageVC :UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RKMessageCell.self)
        let imgStr = dataArray[indexPath.row]["icon"]
        //cell.leftIV.kf.setImage(with: URL(string: imgStr!))
//        cell.leftIV.kf.setImage(urlString: imgStr)
        cell.leftIV.rksetImage(urlString: imgStr)
        cell.contentBtn.rksetImage(urlString: imgStr, for: .normal)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
    }
}


