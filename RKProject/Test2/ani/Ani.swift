//
//  Ani.swift
//  RKProject
//
//  Created by yunbao02 on 2025/4/24.
//

import UIKit

// 生成指定范围内的随机整数
func getRandom(min: Int, max: Int) -> Int {
    return min + Int.random(in: 0...(max - min))
}

class ThumbsUpAni {
    private var imgsList: [UIImage] = []
    private var containerView: UIView
    private var width: CGFloat
    private var height: CGFloat
    private var scanning = false
    private var renderList: [(render: (TimeInterval) -> Bool, duration: TimeInterval, timestamp: TimeInterval)] = []
    private let scaleTime: TimeInterval = 0.1

    init(container: UIView) {
        containerView = container
        width = container.bounds.width
        height = container.bounds.height
        loadImages()
    }

    // 加载图片
    private func loadImages() {
        let imageNames = [
            "good1_30x30_",
            "good2_30x30_", "good3_30x30_", "good4_30x30_", "good5_30x30_", "good6_30x30_", "good7_30x30_", "good8_30x30_", "good9_30x30_",
        ]

        for imageName in imageNames {
            if let image = UIImage(named: imageName) {
                imgsList.append(image)
            }
        }
    }

    // 创建渲染函数
    private func createRender() -> ((TimeInterval) -> Bool)? {
        guard !imgsList.isEmpty else { return nil }
        let basicScale = [0.6, 0.9, 1.2][getRandom(min: 0, max: 2)]

        let getScale = { (diffTime: TimeInterval) -> CGFloat in
            if diffTime < self.scaleTime {
                return CGFloat((diffTime / self.scaleTime).rounded(toPlaces: 2)) * CGFloat(basicScale)
            } else {
                return CGFloat(basicScale)
            }
        }

        let image = imgsList[getRandom(min: 0, max: imgsList.count - 1)]
        let offset: CGFloat = 20
//        let basicX = width / 2 + CGFloat(getRandom(min: -Int(offset), max: Int(offset)))
        let basicX = width * 0.8 + CGFloat(getRandom(min: -Int(offset), max: Int(offset)))
        let angle = CGFloat(getRandom(min: 2, max: 10))
        let ratio = CGFloat(getRandom(min: 10, max: 30)) * (getRandom(min: 0, max: 1) == 0 ? -1 : 1)

        let getTranslateX = { (diffTime: TimeInterval) -> CGFloat in
            if diffTime < self.scaleTime {
                return basicX
            } else {
                return basicX + ratio * sin(angle * CGFloat(diffTime - self.scaleTime))
            }
        }

        let getTranslateY = { (diffTime: TimeInterval) -> CGFloat in
            return CGFloat(image.size.height / 2) + (self.height - CGFloat(image.size.height / 2)) * (1 - CGFloat(diffTime))
        }

        let fadeOutStage = CGFloat(getRandom(min: 14, max: 18)) / 100
        let getAlpha = { (diffTime: TimeInterval) -> CGFloat in
            let left = 1 - CGFloat(diffTime)
            if left > fadeOutStage {
                return 1
            } else {
                return 1 - ((fadeOutStage - left) / fadeOutStage).rounded(toPlaces: 2)
            }
        }

        return { (diffTime: TimeInterval) -> Bool in
            if diffTime >= 1 { return true }

            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            imageView.center = CGPoint(x: getTranslateX(diffTime), y: getTranslateY(diffTime))
            imageView.transform = CGAffineTransform(scaleX: getScale(diffTime), y: getScale(diffTime))
            imageView.alpha = getAlpha(diffTime)

            self.containerView.addSubview(imageView)

            return false
        }
    }

    // 扫描渲染列表
    private func scan() {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        containerView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)

        var index = 0
        let length = renderList.count

        if length > 0 {
            scanning = true
            DispatchQueue.main.asyncAfter(deadline: .now() + (1.0 / 60.0)) {
                self.scan()
            }
        } else {
            scanning = false
        }

        while index < renderList.count {
            let child = renderList[index]
            let diffTime = (Date().timeIntervalSince1970 - child.timestamp) / child.duration
            if child.render(diffTime) {
                renderList.remove(at: index)
            } else {
                index += 1
            }
        }
    }

    // 开始动画
    func start() {
        if let render = createRender() {
            let duration = TimeInterval(getRandom(min: 1500, max: 3000)) / 1000
            renderList.append((render: render, duration: duration, timestamp: Date().timeIntervalSince1970))

            if !scanning {
                scanning = true
                scan()
            }
        }
    }
}

// 扩展 CGFloat 以实现四舍五入功能
extension CGFloat {
    func rounded(toPlaces places: Int) -> CGFloat {
        let divisor = CGFloat(pow(10.0, Double(places)))
        return (self * divisor).rounded() / divisor
    }
}
