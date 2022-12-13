//
//  Lion.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import SpriteKit

class Lion: SKSpriteNode {
    
    // MARK: - Variable Declrations & Initialization
    let LION_WIDTH: CGFloat = 40.0
    let LION_HEIGHT: CGFloat = 40.0
    let LION_COLOR = UIColor.clear
    
    // MARK: - Initializers
    init() {
        let texture = SKTexture(image: R.image.lion() ?? UIImage())
        let size = CGSize(width: LION_WIDTH, height: LION_HEIGHT)
        super.init(texture: texture, color: LION_COLOR, size: size)
        loadPhysicsBodyWithSize(size: size)
        startMoving()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Class Methods
    func loadPhysicsBodyWithSize(size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = MarioPhysicsCategory.enemyCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.contactTestBitMask = MarioPhysicsCategory.heroCategory
    }
    
    func startMoving() {
        let moveLeft = SKAction.moveBy(x: -kDefaultXToMovePerSecond, y: 0, duration: 1)
        run(SKAction.repeatForever(moveLeft))
    }
       
    func stopMoving() {
        removeAllActions()
    }
}
