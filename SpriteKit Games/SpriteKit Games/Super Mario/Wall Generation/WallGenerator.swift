//
//  WallGenerator.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import SpriteKit

class WallGenerator: SKSpriteNode {
    
    var generationTimer: Timer!
    var walls = [Wall]()
    var wallTrackers = [Wall]()
    
    func startGeneratingWallsEvery(seconds: TimeInterval) {
        generationTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(generateWall), userInfo: nil, repeats: true)
    }
    
    func stopGeneratingWalls() {
        generationTimer.invalidate()
    }
    
    @objc func generateWall() {
        var scale: CGFloat
        let random = arc4random_uniform(2)
        if random == 0 {
            scale = -1.0
        } else {
            scale = 1.0
        }
        
        let wall = Wall()
        wall.position.x = size.width / 2 + wall.size.width / 2
        wall.position.y = scale * (kGroundHeight / 2 + wall.size.height / 2)
        walls.append(wall)
        wallTrackers.append(wall)
        addChild(wall)
    }
    
    func stopWalls() {
        stopGeneratingWalls()
        for wall in walls {
            wall.stopMoving()
        }
    }
}
