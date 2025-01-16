//
//  Emitterable.swift
//  RKProject
//
//  Created by yunbao02 on 2025/1/16.
//

import UIKit

protocol Emitterable {}

private var EmitterableKey: UInt8 = 0
extension Emitterable where Self: UIViewController {
    ///
    private var emitterLayer: CAEmitterLayer? {
        get {
            return objc_getAssociatedObject(self, &EmitterableKey) as? CAEmitterLayer
        }
        set {
            objc_setAssociatedObject(self, &EmitterableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func startEmittering(_ point: CGPoint) {
        if let emitterLayer = emitterLayer {
            emitterLayer.birthRate += 1
        } else {
            // 1.创建发射器
            emitterLayer = CAEmitterLayer()
            // 2.设置发射器的位置
            emitterLayer!.emitterPosition = point
            // 3.开启三维效果
            emitterLayer!.preservesDepth = true
            // 设置发射器的模式为点发射
            // emitterLayer!.emitterMode = .points
            // 设置发射器的大小为一个很小的值，因为形状是点
            emitterLayer!.emitterSize = CGSize(width: 0, height: 0)
            // 设置发射器的形状为点
            emitterLayer!.emitterShape = .point

            // 4.创建粒子并设置粒子相关属性
            var cells = [CAEmitterCell]()
            for i in 1..<10 {
                // 4.1.创建粒子cell
                let cell = CAEmitterCell()
                // 4.2.设置粒子速度
                cell.velocity = 100
                cell.velocityRange = 50
                // 4.3.设置粒子的大小
                cell.scale = 0.7
                cell.scaleRange = 0.3
                // 4.4.设置粒子方向
                cell.emissionLongitude = CGFloat(-(Double.pi / 2))
                // 角度
                cell.emissionRange = CGFloat((Double.pi / 4) / 2)
                // 4.5.设置粒子存活时间
                cell.lifetime = 5
                cell.lifetimeRange = 1.5
                // 4.6.设置粒子旋转
                cell.spin = CGFloat(Double.pi / 2)
                cell.spinRange = CGFloat((Double.pi / 2) / 2)
                // 4.7.设置粒子每秒弹出的个数
                cell.birthRate = 5
                // 4.8.设置粒子展示的图片
                cell.contents = UIImage(named: "good\(i)_30x30_")?.cgImage
                // 4.9.添加到数组中
                cells.append(cell)
            }
            // 5.将粒子设置到发射器中
            emitterLayer!.emitterCells = cells
            // 6.将发射器的layer添加到父layer中
            view.layer.addSublayer(emitterLayer!)
        }
        debug.log("start:\(emitterLayer!.birthRate),count:\(emitterLayer?.emitterCells?.count ?? 999)")
    }

    ///
    func stopEmittering() {
        emitterLayer?.birthRate -= 1
        debug.log("stop")
    }

    ///
    func destroyEmitter() {
        // view.layer.sublayers?.filter { $0.isKind(of: CAEmitterLayer.self) }.first?.removeFromSuperlayer()
        emitterLayer?.removeAllAnimations()
        emitterLayer?.removeFromSuperlayer()
    }
}
