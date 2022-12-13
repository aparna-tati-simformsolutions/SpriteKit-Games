//
//  CloudGenerator.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import Foundation
import SpriteKit

class CloudGenerator: SKSpriteNode {
    
    // MARK: - Variable Declrations & Initialization
    let CLOUD_WIDTH: CGFloat = 125.0
    let CLOUD_HEIGHT: CGFloat = 55.0
    var generationTimer: Timer!
    
    // MARK: - Class Methods
    func populate(num: Int) {
        var i = 0
        if i < num {
            i += 1
            let cloud = Cloud(size: CGSize(width: CLOUD_WIDTH, height: CLOUD_HEIGHT))
            let x = CGFloat(arc4random_uniform(UInt32(size.width))) - size.width / 2
            let y = CGFloat(arc4random_uniform(UInt32(size.height))) - size.height / 2
            cloud.position = CGPoint(x: x, y: y)
            cloud.zPosition = -1
            addChild(cloud)
        }
    }
    
    func startGeneratingWithSpawnTime(seconds: TimeInterval) {
        generationTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(generateCloud),userInfo: nil, repeats: true)
    }
    
    // MARK: - Objective Methods
    @objc func generateCloud() {
        let x = size.width / 2 + CLOUD_WIDTH / 2
        let y = CGFloat(arc4random_uniform(UInt32(size.height))) - size.height / 2
        let cloud = Cloud(size: CGSize(width: CLOUD_WIDTH, height: CLOUD_HEIGHT))
        cloud.position = CGPoint(x: x, y: y)
        cloud.zPosition = -1
        addChild(cloud)
    }
    
    func stopGenerating() {
        generationTimer.invalidate()
    }
}
