//
//  EmitterableVC2.swift
//  RKProject
//
//  Created by yunbao02 on 2025/4/24.
//

import UIKit

// good1_30x30_
// private let imageNames = ["good1_30x30_", "good2_30x30_", "good3_30x30_"]

class EmitterableVC2: RKBaseVC {
    // 创建 CAEmitterLayer
    private let emitterLayer: CAEmitterLayer = {
        let layer = CAEmitterLayer()
        layer.emitterShape = .point
        layer.emitterMode = .points
        return layer
    }()

    // 图片名称数组
    private let imageNames = ["good1_30x30_", "good2_30x30_", "good3_30x30_"]

    // 存储每个 CAEmitterCell 的原始发射速率
    private var originalBirthRates: [Float] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置 emitterLayer 的位置和大小
        emitterLayer.frame = view.bounds
        view.layer.addSublayer(emitterLayer)

        var emitterCells = [CAEmitterCell]()
        // 为每张图片创建一个 CAEmitterCell
        for imageName in imageNames {
            let emitterCell = CAEmitterCell()
            if let image = UIImage(named: imageName) {
                emitterCell.contents = image.cgImage
            }
            // 粒子的发射速率
            emitterCell.birthRate = 1
            // 粒子的生命周期
            emitterCell.lifetime = 3.0
            // 粒子的发射速度
            emitterCell.velocity = 300
            // 粒子的发射角度范围，这里调整为朝向屏幕宽的一半且高度 100 的方向
            let targetX = view.bounds.midX
            let targetY = 100.0
            let currentX = view.bounds.maxX
            let currentY = view.bounds.maxY
            let dx = targetX - currentX
            let dy = targetY - currentY
            let angle = atan2(dy, dx)
            emitterCell.emissionRange = .pi / 6 // 给一个小的角度范围让粒子有一定分散度
            emitterCell.emissionLongitude = angle
            // 粒子的缩放比例
            emitterCell.scale = 0.5
            // 粒子的缩放速度，让粒子在生命周期内有缩放效果
            emitterCell.scaleSpeed = -0.1
            // 粒子的透明度变化速度，让粒子在生命周期内逐渐消失
            emitterCell.alphaSpeed = -0.5
            emitterCells.append(emitterCell)
            originalBirthRates.append(emitterCell.birthRate)
        }

        // 将所有 emitterCell 添加到 emitterLayer
        emitterLayer.emitterCells = emitterCells
        // 设置发射位置为屏幕右下角
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.maxX, y: view.bounds.maxY)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first != nil else { return }

        // 遍历所有 emitterCell 并临时增加发射速率
        for (index, cell) in (emitterLayer.emitterCells ?? []).enumerated() {
            debug.log("\(index) == \(cell) ==\(originalBirthRates.count)")
            cell.birthRate += 0.5
            // 3.0 秒后恢复发射速率
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                cell.birthRate = self.originalBirthRates[index]
                debug.log("===> \(index) == \(cell) ==\(self.originalBirthRates.count)")
            }
        }
    }
}
