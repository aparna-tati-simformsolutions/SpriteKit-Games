//
//  LionGenerator.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import SpriteKit

class LionGenerator: SKSpriteNode {
    
    var generationTimer: Timer!
    var lions = [Lion]()
    var lionTrackers = [Lion]()
    
    func startGeneratingLionsEvery(seconds: TimeInterval) {
        generationTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(generateLion), userInfo: nil, repeats: true)
    }
    
    func stopGenerating() {
        generationTimer.invalidate()
    }
    
    @objc func generateLion() {
        var scale: CGFloat
        let random = arc4random_uniform(2)
        if random == 0 {
            scale = 1.0
        } else {
            scale = 1.0
        }
        
        let enemy = Lion()
        enemy.position.x = size.width / 2 + enemy.size.width / 2
        enemy.position.y = scale * (kGroundHeight / 2 + enemy.size.height / 2)
        lions.append(enemy)
        lionTrackers.append(enemy)
        addChild(enemy)
    }
    
    func stopLions() {
        stopGenerating()
        for lion in lions {
            lion.stopMoving()
        }
    }
    
}


