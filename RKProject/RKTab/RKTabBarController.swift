//
//  RKTabBarController.swift
//  RKProject
//
//  Created by YB007 on 2020/11/21.
//

import UIKit

class RKTabBarController: UITabBarController, CAAnimationDelegate{
    
    var onlyTitle = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildrenControllers()
        setCenterButton()
        
        //  UITabBar.appearance().shadowImage = UIImage()
        //  UITabBar.appearance().backgroundImage = UIImage()
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
        
        // title
        subVC.tabBarItem.title = title
        let attrNor = [
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.font : UIFont.rkFont(ofSize: 20)
        ]
        let attrSel = [
            NSAttributedString.Key.foregroundColor : UIColor.orange,
            NSAttributedString.Key.font : UIFont.rkFont(ofSize: 20)
        ]
        subVC.tabBarItem.setTitleTextAttributes(attrNor, for: .normal)
        subVC.tabBarItem.setTitleTextAttributes(attrSel, for: .selected)
        
        if onlyTitle {
            // 只显示文字
            subVC.tabBarItem.image = UIImage();
            subVC.tabBarItem.selectedImage = UIImage();
            subVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -12);
        }else{
            // image
            let iconNor = "tabbar_" + image
            let iconSel = iconNor + "_selected"
            var norImg = UIImage(named: iconNor)
            norImg = norImg?.withRenderingMode(.alwaysOriginal)
            subVC.tabBarItem.image = norImg
            var selImg = UIImage(named: iconSel)
            selImg = selImg?.withRenderingMode(.alwaysOriginal)
            subVC.tabBarItem.selectedImage = selImg
        }
        
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
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let clickIdx = self.tabBar.items?.firstIndex(of: item)
        if clickIdx != self.selectedIndex {
            executeAnim(clickIdx!)
        }
    }
    
    // item ani
    /**
    NSMutableArray *tabbarbuttonArray = [NSMutableArray array];
    //找到所有的 UITabBarButton
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    //动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[[self scaleAnimation], [self rotationAnimation]];
    group.duration = 0.15;
    UIView *tabbarBtn = tabbarbuttonArray[index];
    //找到UITabBarButton中的imageView，加动画
    for (UIView *sub in tabbarBtn.subviews) {
        if ([sub isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            [sub.layer addAnimation:group forKey:nil];
            //音效
            AudioServicesPlaySystemSound(1109);
        }
    }
    */
    func executeAnim(_ index:Int) {
        let m_array = NSMutableArray()
        for subView in self.tabBar.subviews {
            if subView.isKind(of: NSClassFromString("UITabBarButton")!) {
                m_array.add(subView)
            }
        }
        let group = CAAnimationGroup()
        // group.animations = [scaleAni(),rotationAni()]
        group.animations = [scaleAni()]
        group.duration = 0.5
        group.delegate = self
        let tabItem = m_array[index] as! UIView
        tabItem.layer.add(group, forKey: "groupAni")
        /*
        for subView in tabItem.subviews {
            if subView.isKind(of: NSClassFromString("UITabBarSwappableImageView")!) {
                subView.layer.add(group, forKey: "groupAni")
            }
        }
        */
    }
    // 动画监听
    nonisolated func animationDidStart(_ anim: CAAnimation) {
        rkprint("====>ani-start\(anim)")
    }
    nonisolated func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        rkprint("====>ani-stop\(anim)===>\(flag)")
    }
    
    // 大小
    /**
     CABasicAnimation *scaleAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
     scaleAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
     scaleAni.repeatCount = 1;
     scaleAni.autoreverses = YES;
     scaleAni.fromValue = [NSNumber numberWithFloat:1];
     scaleAni.toValue = [NSNumber numberWithFloat:0.5];
     */
    func scaleAni() -> CAKeyframeAnimation {
        /*
        let scaleAni = CABasicAnimation(keyPath: "transform.scale")
        scaleAni.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scaleAni.repeatCount = 2
        scaleAni.autoreverses = true
        scaleAni.fromValue = NSNumber(value: 1)
        scaleAni.toValue = NSNumber(value: 1.1)
        */
        let scaleAni = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAni.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scaleAni.repeatCount = 1
        scaleAni.autoreverses = true
        scaleAni.values = [NSNumber(value: 1),NSNumber(value: 1.2),NSNumber(value: 1.3),NSNumber(value: 1.2),NSNumber(value: 1)]
        return scaleAni
    }
    // 旋转
    /**
     CABasicAnimation *rotateAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
     rotateAni.fromValue = @(0);
     rotateAni.toValue = @(M_PI);
     rotateAni.repeatCount = 1;
     */
    func rotationAni() -> CABasicAnimation {
        let rotateAni = CABasicAnimation(keyPath: "transform.rotation.y")
        rotateAni.fromValue = NSNumber(value: 0)
        rotateAni.toValue = NSNumber(value: Double.pi)
        rotateAni.repeatCount = 1;
        return rotateAni
    }
}

extension RKTabBarController : UITabBarControllerDelegate {
    
    func  tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //当前控制器index
        let index = children.firstIndex(of: viewController)
        rkprint("will switch to \(viewController)\n pre:\(selectedIndex) now:\(index ?? 11111)")
        
        //在首页，又点击了”首页“tabbar, ==> 滚动到顶部
        if selectedIndex == 0 && index == 0{
            /**
             let navi = children[0] as! RKNavigationController
             let vc = navi.children[0] as! RKHomeVC
             //scroll to top
             //vc.tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
             // FIXME: dispatch work around.(必须滚动完,再刷新)
             DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                vc.clickNaviRightBtn()
             }
             //clear badgeNumber
             vc.tabBarItem.badgeValue = nil
             UIApplication.shared.applicationIconBadgeNumber = 0
             */
        }
        return !viewController.isMember(of: UIViewController.self)
    }
    
}
