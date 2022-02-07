//
//  RKTabBarController.swift
//  RKProject
//
//  Created by YB007 on 2020/11/21.
//

import UIKit

class RKTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildrenControllers()
        setCenterButton()
        
//        UITabBar.appearance().shadowImage = UIImage()
//        UITabBar.appearance().backgroundImage = UIImage()
        
        UITabBar.appearance().tintColor = .orange
        UITabBar.appearance().unselectedItemTintColor = .gray
        delegate = self
        
    }
    
    private func setupChildrenControllers(){
        
        //
        let hVC = RKHomeVC()
        let homeNavi = setSubViewController(title: rkLocalized(key: "首页"), image: "home", subVC: hVC)
        
        //
        let mVC = RKMessageVC()
        let mNavi = setSubViewController(title: rkLocalized(key: "消息"), image: "message_center", subVC: mVC)
        
        //
        let space = UIViewController()
        
        //
        let fVC = RKDiscoverVC()
        let fNavi = setSubViewController(title: rkLocalized(key: "发现"), image: "discover", subVC: fVC)
        
        //
        let mineVC = RKMineVC()
        let mineNavi = setSubViewController(title: rkLocalized(key: "我的"), image: "profile", subVC: mineVC)
        
        viewControllers = [homeNavi,mNavi,space,fNavi,mineNavi]
        
    }
    
    private func setSubViewController(title: String, image: String, subVC: UIViewController) -> RKNavigationController{
        
        let iconNor = "tabbar_" + image
        let iconSel = iconNor + "_selected"
        
        var norImg = UIImage(named: iconNor)
        norImg = norImg?.withRenderingMode(.alwaysOriginal)
        subVC.tabBarItem.image = norImg
        
        var selImg = UIImage(named: iconSel)
        selImg = selImg?.withRenderingMode(.alwaysOriginal)
        subVC.tabBarItem.selectedImage = selImg
        
//        let attrNor = [
//            NSAttributedString.Key.foregroundColor : UIColor.gray,
//            NSAttributedString.Key.font : UIFont.rkFont(ofSize: 13)
//        ]
//        let attrSel = [
//            NSAttributedString.Key.foregroundColor : UIColor.orange,
//            NSAttributedString.Key.font : UIFont.rkFont(ofSize: 13)
//        ]
        subVC.tabBarItem.title = title
//        subVC.tabBarItem.setTitleTextAttributes(attrNor, for: .normal)
//        subVC.tabBarItem.setTitleTextAttributes(attrSel, for: .selected)
        
        let navi = RKNavigationController(rootViewController: subVC)
        navi.navigationController?.isNavigationBarHidden = true
        return navi
    }
    
    private func setCenterButton(){
        
        let centerBtn = UIButton()
        centerBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: .normal)
        centerBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: .normal)
        tabBar.addSubview(centerBtn)
        
        let count = CGFloat(viewControllers?.count ?? 0)
        let width = tabBar.bounds.width / count
        let leftItemCount:CGFloat = 2
        centerBtn.frame = tabBar.bounds.insetBy(dx: leftItemCount * width, dy: 0)
        centerBtn.addTarget(self, action: #selector(centerBtnClick), for: .touchUpInside)
        
    }
    
    @objc private func centerBtnClick(){
        
        //rkprint("ooooooooooocenter");
        
        let cuss = RkProjectTestVC()
        UIApplication.shared.pushViewController(cuss, animated: true)
    }
    
}

extension RKTabBarController : UITabBarControllerDelegate {
    
    func  tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       
        //当前控制器index
        let index = children.firstIndex(of: viewController)
        
        rkprint("will switch to \(viewController)\n pre:\(selectedIndex) now:\(index ?? 11111)")
        
        //在首页，又点击了”首页“tabbar, ==> 滚动到顶部
        if selectedIndex == 0 && index == 0{
            /*
            let navi = children[0] as! RKNavigationController
            let vc = navi.children[0]
            
            //scroll to top
            //vc.tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
            //FIXME: dispatch work around.(必须滚动完,再刷新)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                 vc.loadDatas()
            }
            
            //clear badgeNumber
            vc.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
            */
        }
        
        return !viewController.isMember(of: UIViewController.self)
        
    }
    
    
}
