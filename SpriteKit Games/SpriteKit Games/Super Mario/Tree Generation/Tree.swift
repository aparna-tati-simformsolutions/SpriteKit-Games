//
//  Tree.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import SpriteKit

class Tree: SKSpriteNode {
    
    let TREE_WIDTH: CGFloat = 30.0
    let TREE_HEIGHT: CGFloat = 30.0
    let TREE_COLOR = UIColor.clear
    
    init() {
        let enemyImage = R.image.tree()
        let texture = SKTexture(image: enemyImage ?? UIImage())
        let size = CGSize(width: TREE_WIDTH, height: TREE_HEIGHT)
        super.init(texture: texture, color: TREE_COLOR, size: size)
        loadPhysicsBodyWithSize(size: size)
        startMoving()
    }
    
    func loadPhysicsBodyWithSize(size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = treeCategory
        physicsBody?.affectedByGravity = false
        physicsBody?.contactTestBitMask = heroCategory
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving() {
        let moveLeft = SKAction.moveBy(x: -kDefaultXToMovePerSecond, y: 0, duration: 1)
        run(SKAction.repeatForever(moveLeft))
    }
       
    func stopMoving() {
        removeAllActions()
    }
}

