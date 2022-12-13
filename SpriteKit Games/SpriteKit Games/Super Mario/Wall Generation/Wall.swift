//
//  Wall.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import SpriteKit

class Wall: SKSpriteNode {
    
    let WALL_WIDTH: CGFloat = 20.0
    let WALL_HEIGHT: CGFloat = 30.0
    let WALL_COLOR = UIColor.black
    
    init() {
        let size = CGSize(width: WALL_WIDTH, height: WALL_HEIGHT)
        super.init(texture: nil, color: WALL_COLOR, size: size)
        
        loadPhysicsBodyWithSize(size: size)
        startMoving()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadPhysicsBodyWithSize(size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = enemyCategory
        physicsBody?.affectedByGravity = false
    }
    
    func startMoving() {
        let moveLeft = SKAction.moveBy(x: -kDefaultXToMovePerSecond, y: 0, duration: 1)
        run(SKAction.repeatForever(moveLeft))
    }
    
    func stopMoving() {
        removeAllActions()
    }
}
