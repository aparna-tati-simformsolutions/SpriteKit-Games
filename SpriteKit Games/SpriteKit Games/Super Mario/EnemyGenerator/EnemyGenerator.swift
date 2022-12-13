//
//  WallGenerator.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import SpriteKit

class EnemyGenerator: SKSpriteNode {
    
    // MARK: - Variable Declrations & Initialization
    var generationTimer: Timer!
    var walls = [Wall]()
    var wallTrackers = [Wall]()
    var lions = [Lion]()
    var lionTrackers = [Lion]()
    
    // MARK: - Class Methods
    func startGeneratingEnemyEvery(seconds: TimeInterval) {
        generationTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(generateEnemies), userInfo: nil, repeats: true)
    }
    
    func stopGeneratingEnemies() {
        generationTimer.invalidate()
    }
    
    func stopMovingEnemies() {
        stopGeneratingEnemies()
        for wall in walls {
            wall.stopMoving()
        }
        for lion in lions {
            lion.stopMoving()
        }
    }
    
    // MARK: - Objective Methods
    @objc func generateEnemies() {
        var scale: CGFloat
        let random = arc4random_uniform(2)
        if random % 2 == 0 {
            scale = -1.0
            let wall = Wall()
            wall.position.x = size.width / 2 + wall.size.width / 2
            wall.position.y = scale * (kGroundHeight / 2 + wall.size.height / 2)
            walls.append(wall)
            wallTrackers.append(wall)
            addChild(wall)
        } else {
            scale = 1.0
            let enemy = Lion()
            enemy.position.x = size.width / 2 + enemy.size.width / 2
            enemy.position.y = scale * (kGroundHeight / 2 + enemy.size.height / 2)
            lions.append(enemy)
            lionTrackers.append(enemy)
            addChild(enemy)
        }
    }
}
