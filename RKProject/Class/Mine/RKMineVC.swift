//
//  RKMineVC.swift
//  RKProject
//
//  Created by YB007 on 2020/11/25.
//

import UIKit

class RKMineVC: RKBaseVC {

    
    private lazy var listTableView: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.backgroundColor = rkBackGroundCor
        tab.separatorStyle = .none
        tab.estimatedSectionHeaderHeight = 0
        tab.estimatedSectionFooterHeight = 0
        tab.register(cellType: RKMineCell.self)
        tab.rkHead = RkRefreshHeader { [weak self] in
            self?.refreshTbale()
        }
        tab.rkFoot = RkRefreshTipKissFooter {[weak self] in
            self?.refreshTbale()
        }
        return tab
    }()
    
    var dataArray:Array<Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftItem.isHidden = true
        titleL.text = rkLocalized(key: "我的").appending(" Top")
        
        if rkLanguageType().isEqual(rkEn) {
            dataArray = [["title":"first"],["title":"second"],["title":"third"]]
        }else{
            dataArray = [["title":"第一个标题"],["title":"第二个标题"],["title":"第三个标题"]]
        }
        
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
    
    func refreshTbale() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) { [weak self] in
            self?.listTableView.rkHead.endRefreshing()
            self?.listTableView.rkFoot.endRefreshing()
        }
        
    }

    
}


extension RKMineVC: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RKMineCell.self)
        cell.dataDic = dataArray[indexPath.row] as? Dictionary<String, Any>
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let setVC = RKSetVC()
        UIApplication.shared.pushViewController(setVC, animated: true)
//        UIApplication.shared.present(setVC, animated: true, completion: nil)
    }

}
