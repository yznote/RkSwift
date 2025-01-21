//
//  LyNetwork.swift
//  RKProject
//
//  Created by yunbao02 on 2024/12/10.
//

import UIKit

class LyNetwork: @unchecked Sendable {
    var isHUDShown:Bool = false
    
    static let shared: LyNetwork = {
        // 先定义instance为可选类型
        var instance: LyNetwork?
        let queue = DispatchQueue(label: "com.lynetwork.singleton")
        queue.sync {
            // 在闭包内安全地初始化instance
            instance = LyNetwork()
        }
        // 使用可选绑定确保instance有值后再返回，如果没有值会触发运行时错误，不过在正常逻辑下不会出现这种情况，因为闭包内会进行初始化
        guard let unwrappedInstance = instance else {
            fatalError("Singleton instance not initialized")
        }
        return unwrappedInstance
    }()
    private init() {
        // 私有初始化方法，防止外部直接初始化
        /* swift 中不允许使用 dispatch_once
        var onceToken: dispatch_once_t = 0
        var instance: LyNetwork?
        dispatch_once(&onceToken, {
            instance = LyNetwork()
        })
        */
    }
    
    func test(_ url: String) {
        let session = URLSession.shared
        let task = session.dataTask(with: URL(string: url)!) { (data, response, error) in
            // 回到主线程处理请求完成后的逻辑，比如隐藏HUD（如果已显示）
            DispatchQueue.main.async {
                self.hideHUD()
                if let error = error {
                    print("请求出错: \(error)")
                } else {
                    // 在这里处理请求成功返回的数据
                    print("请求成功，数据处理逻辑")
                }
            }
        }
        task.resume()
        // 使用DispatchQueue定时器，5秒后检查是否显示HUD
        DispatchQueue.main.asyncAfter(deadline:.now() + 5) {
            self.showHUD(task)
        }
    }
    
    @MainActor func hideHUD(){
        if self.isHUDShown {
            rkHideHud()
            self.isHUDShown = false
        }
    }
    
    @MainActor func showHUD(_ task:URLSessionTask) {
        // print("====>[state]\(task.state)===>\(self.isHUDShown)")
        if task.state == .running && !self.isHUDShown {
            self.isHUDShown = true
            rkLoadingHud()
            // print("====>show:\(self.isHUDShown)")
        }
    }
    
}
