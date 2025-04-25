//
//  LikeAnimation.swift
//  RKProject
//
//  Created by yunbao02 on 2025/4/25.
//

import UIKit

class LikeAnimation: NSObject {
    static func showTheApplauseInView(_ view: UIView, belowView v: UIButton) {
        // let index = arc4random_uniform(7) // 取随机图片
        let index = Int.random(in: 1...9)
        let imageName = "good\(index)_30x30_"
        let applauseView = UIImageView(frame: CGRect(x: view.frame.size.width - 15 - 50, y: view.frame.size.height - 150, width: 40, height: 40))
        view.insertSubview(applauseView, belowSubview: v)
        applauseView.image = UIImage(named: imageName)

        let animHeight: CGFloat = 350 // 动画路径高度
        applauseView.transform = CGAffineTransform(scaleX: 0, y: 0)
        applauseView.alpha = 0

        // 弹出动画
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            applauseView.transform = .identity
            applauseView.alpha = 0.9
        }

        // 随机偏转角度
        let i = arc4random_uniform(2)
        let rotationDirection = 1 - (2 * Int(i)) // -1 OR 1, 随机方向
        let rotationFraction = arc4random_uniform(10) // 随机角度
        // 图片在上升过程中旋转
        UIView.animate(withDuration: 4) {
            applauseView.transform = CGAffineTransform(rotationAngle: CGFloat(rotationDirection) * .pi / (4 + CGFloat(rotationFraction) * 0.2))
        }

        // 动画路径
        let heartTravelPath = UIBezierPath()
        heartTravelPath.move(to: applauseView.center)

        // 随机终点
        let viewX = applauseView.center.x
        let viewY = applauseView.center.y
        let endPoint = CGPoint(x: viewX + CGFloat(rotationDirection) * 10, y: viewY - animHeight)

        // 随机 control 点
        let j = arc4random_uniform(2)
        let travelDirection = 1 - (2 * Int(j)) // 随机方向 -1 OR 1

        let m1 = viewX + CGFloat(travelDirection) * CGFloat(arc4random_uniform(20) + 50)
        let n1 = viewY - 60 + CGFloat(travelDirection) * CGFloat(arc4random_uniform(20))
        let m2 = viewX - CGFloat(travelDirection) * CGFloat(arc4random_uniform(20) + 50)
        let n2 = viewY - 90 + CGFloat(travelDirection) * CGFloat(arc4random_uniform(20))
        let controlPoint1 = CGPoint(x: m1, y: n1) // control 根据自己动画想要的效果做灵活的调整
        let controlPoint2 = CGPoint(x: m2, y: n2)
        // 根据贝塞尔曲线添加动画
        heartTravelPath.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)

        // 关键帧动画, 实现整体图片位移
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
        keyFrameAnimation.path = heartTravelPath.cgPath
        keyFrameAnimation.timingFunction = CAMediaTimingFunction(name: .default)
        keyFrameAnimation.duration = 3 // 往上飘动画时长, 可控制速度
        applauseView.layer.add(keyFrameAnimation, forKey: "positionOnPath")

        // 消失动画
        UIView.animate(withDuration: 3) {
            applauseView.alpha = 0.0
        } completion: { finished in
            applauseView.removeFromSuperview()
        }
    }
}
