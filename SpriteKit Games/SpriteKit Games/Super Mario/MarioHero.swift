//
//  MarioHero.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import Foundation
import SpriteKit

class MarioHero: SKSpriteNode {
    
    var body: SKSpriteNode!
    var arm: SKSpriteNode!
    var leftFoot: SKSpriteNode!
    var rightFoot: SKSpriteNode!
    
    var inUpSideDown = false
    
    init() {
        let size = CGSize(width: 32, height: 44)
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        loadAppearance()
        loadPhysicsBodyWithSize(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAppearance() {
        body = SKSpriteNode(color: UIColor.black, size: CGSize(width: self.frame.size.width, height: 40))
        body.position = CGPoint(x: 0, y: 2)
        addChild(body)
        
        let skinColor = UIColor(red: 207.0/255.0, green: 193.0/255.0, blue: 168.0/255.0, alpha: 1)
        let face = SKSpriteNode(color: skinColor, size: CGSize(width: self.frame.size.width, height: 12))
        face.position = CGPoint(x: 0, y: 6)
        body.addChild(face)
        
        let eyeColor = UIColor.white
        let leftEye = SKSpriteNode.init(color: eyeColor, size: CGSize(width: 6, height: 6))
        let rightEye = leftEye.copy() as! SKSpriteNode
        
        let pupil = SKSpriteNode(color: UIColor.black, size: CGSize(width: 3, height: 3))
        pupil.position = CGPoint(x: 2, y: 0)
        leftEye.addChild(pupil)
        rightEye.addChild(pupil.copy() as! SKSpriteNode)
        
        leftEye.position = CGPoint(x: -4, y: 0)
        face.addChild(leftEye)
        
        rightEye.position = CGPoint(x: 14, y: 0)
        face.addChild(rightEye)
        
        let eyebrow = SKSpriteNode(color: UIColor.black, size: CGSize(width: 11, height: 1))
        eyebrow.position = CGPoint(x: -1, y: leftEye.size.height / 2)
        leftEye.addChild(eyebrow)
        rightEye.addChild(eyebrow.copy() as! SKSpriteNode)
        
        let armColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1)
        arm = SKSpriteNode(color: armColor, size: CGSize(width: 8, height: 14))
        arm.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        arm.position = CGPoint(x: -10, y: -7)
        body.addChild(arm)
        
        let hand = SKSpriteNode(color: skinColor, size: CGSize(width: arm.size.width, height: 5))
        hand.position = CGPoint(x: -arm.size.height*0.9, y: hand.size.height/2)
        arm.addChild(hand)
        
        leftFoot = SKSpriteNode(color: UIColor.black, size: CGSize(width: 9, height: 4))
        leftFoot.position = CGPoint(x: -6, y: -size.height/2 + leftFoot.size.height/2)
        addChild(leftFoot)
        
        rightFoot = leftFoot.copy() as? SKSpriteNode
        rightFoot.position.x = 8
        addChild(rightFoot)
    }
    
    func loadPhysicsBodyWithSize(size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = heroCategory
        physicsBody?.contactTestBitMask = enemyCategory
        physicsBody?.affectedByGravity = false
    }
    
    func flip() {
        inUpSideDown = !inUpSideDown
        
        var scale: CGFloat!
        if inUpSideDown {
            scale = -1.0
        } else {
            scale = 1.0
        }
        
        let translate = SKAction.moveBy(x: 0, y: scale*(size.height + kGroundHeight), duration: 0.1)
        let flip = SKAction.scaleY(to: scale, duration: 0.1)
        
        run(translate)
        run(flip)
    }
    
    func fall() {
        physicsBody?.affectedByGravity = true
        physicsBody?.applyImpulse(CGVector(dx: -5, dy: 30))
        
        let rotateBack = SKAction.rotate(byAngle: CGFloat(Double.pi)/2, duration: 0.4)
        run(rotateBack)
    }
    
    func startRunning() {
        let rotateBack = SKAction.rotate(byAngle: -CGFloat(Double.pi)/2, duration: 0.1)
        arm.run(rotateBack)
    }
    
    func performOneRunCycle() {
        let up = SKAction.moveBy(x: 0, y: 2, duration: 0.05)
        let down = SKAction.moveBy(x: 0	, y: -2, duration: 0.05)
        
        leftFoot.run(up, completion: { () -> Void in
            self.leftFoot.run(down)
            self.rightFoot.run(up, completion: { () -> Void in
                self.rightFoot.run(down, completion: { () -> Void in
                    self.performOneRunCycle()
                })
            })
        })
    }
    
    func breathe() {
        let breatheOut = SKAction.moveBy(x: 0, y: -2, duration: 1)
        let breathIn = SKAction.moveBy(x: 0, y: 2, duration: 1)
        let breath = SKAction.sequence([breatheOut, breathIn])
        body.run(SKAction.repeatForever(breath))
    }
    
    func stop() {
        body.removeAllActions()
        leftFoot.removeAllActions()
        rightFoot.removeAllActions()
    }
}
