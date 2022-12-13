//
//  BunnyScene.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 13/12/22.
//

import SpriteKit
import GameplayKit

enum BunnySceneState {
    case active, gameOver
}

class BunnyScene: SKScene {
    var hero: SKSpriteNode!
    var scrollGroundNode: SKNode!
    var scrollCloudNode: SKNode!
    var obstacleSource: SKNode!
    var obstacleLayer: SKNode!
    var scoreLabel: SKLabelNode!
    var resetButton: CustomButton!
    var sinceTouch : CFTimeInterval = 0
    var fixedDelta: CFTimeInterval = 1.0 / 60.0
    var groundScrollSpeed: CGFloat = 100
    var cloudScrollSpeed: CGFloat = 25
    var obstacleGenerationTimer: CFTimeInterval = 0
    var points = 0
    var gameState: BunnySceneState = .active
    var previousScore = 0
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsWorld.contactDelegate = self
        previousScore = UserDefaults.standard.integer(forKey: R.string.localizable.previousScore())
        heroSetup()
        obstacleSetup()
        scrollGroundLayerSetup()
        scrollCloudLayerSetup()
        resetButtonSetup()
        actionSetup()
        scoreLabelSetup()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameState != .active { return }
        // Limits the jumping functionality
        let velocityY = hero.physicsBody?.velocity.dy ?? 0
        if velocityY > 400 {
            hero.physicsBody?.velocity.dy = 400
        }
        scrollGrounds()
        scrollObstacles()
        scrollClouds()
        obstacleGenerationTimer += fixedDelta
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState != .active { return }
        // Hero move up direction when touch is began
        physicsWorld.gravity = CGVector(dx: 0, dy: 9.8)
        hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Hero move down direction when touch is ended
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))
    }
    
    func heroSetup() {
        hero = SKSpriteNode(fileNamed: R.string.localizable.hero())
        hero.isPaused = false
    }
    
    func obstacleSetup() {
        obstacleLayer = self.childNode(withName: R.string.localizable.obstacleLayer())
        obstacleSource = self.childNode(withName: R.string.localizable.obstacle())
    }
    
    func scrollGroundLayerSetup() {
        scrollGroundNode = self.childNode(withName: R.string.localizable.scrollGroundlLayer())
    }
    
    func scrollCloudLayerSetup() {
        scrollCloudNode = self.childNode(withName: R.string.localizable.scrollCloudLayer())
    }
    
    func resetButtonSetup() {
        resetButton = self.childNode(withName: R.string.localizable.resetButton()) as? CustomButton
        resetButton.selectedHandler = {
            if let view = self.view {
                if let scene = SKScene(fileNamed: R.string.localizable.bunnyScene()) {
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene)
                }
            }
        }
        resetButton.state = .Hidden
    }
    
    func actionSetup() {
        let shakeAction: SKAction = SKAction.init(named: R.string.localizable.shake())!
        for node in self.children {
            node.run(shakeAction)
        }
    }
    
    func scoreLabelSetup() {
        scoreLabel = self.childNode(withName: R.string.localizable.scoreLabel()) as? SKLabelNode
        scoreLabel.text = "\(points)"
    }
    
    func scrollGrounds() {
        scrollGroundNode.position.x -= groundScrollSpeed * CGFloat(fixedDelta)
        for ground in scrollGroundNode.children as! [SKSpriteNode] {
            let groundPosition = scrollGroundNode.convert(ground.position, to: self)
            if groundPosition.x <= -ground.size.width / 2 {
                let newPosition = CGPoint(x: (self.size.width / 2) + ground.size.width, y: groundPosition.y)
                ground.position = self.convert(newPosition, to: scrollGroundNode)
            }
        }
    }
    
    func scrollClouds() {
        scrollCloudNode.position.x -= cloudScrollSpeed * CGFloat(fixedDelta)
        for cloud in scrollCloudNode.children as! [SKSpriteNode] {
            let cloudPosition = scrollCloudNode.convert(cloud.position, to: self)
            if cloudPosition.x <= -cloud.size.width / 2 {
                let newPosition = CGPoint(x: (self.size.width / 2) + cloud.size.width, y: cloudPosition.y)
                cloud.position = self.convert(newPosition, to: scrollCloudNode)
            }
        }
    }
    
    func scrollObstacles() {
        obstacleLayer.position.x -= groundScrollSpeed * CGFloat(fixedDelta)
        for obstacle in obstacleLayer.children as! [SKReferenceNode] {
            let obstaclePosition = obstacleLayer.convert(obstacle.position, to: self)
            if obstaclePosition.x <= -26 {
                obstacle.removeFromParent()
            }
        }
        if obstacleGenerationTimer >= 1.5 {
            guard let obstacleSource = obstacleSource else { return }
            let newObstacle = obstacleSource.copy() as! SKNode
            obstacleLayer.addChild(newObstacle)
            newObstacle.zPosition = 0
            let randomPosition =  CGPoint(x: 249, y: CGFloat.random(in: 234...382))
            newObstacle.position = self.convert(randomPosition, to: obstacleLayer)
            obstacleGenerationTimer = 0
        }
    }
}

extension BunnyScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        if bodyA.node?.name == R.string.localizable.goal() || bodyB.node?.name == R.string.localizable.goal() {
            points += 1
            scoreLabel.text = String(points)
            UserDefaults.standard.set(scoreLabel.text, forKey: R.string.localizable.previousScore())
            return
        }
        if gameState != .active { return }
        gameState = .gameOver
        hero.physicsBody?.allowsRotation = false
        hero.physicsBody?.angularVelocity = 0
        hero.removeAllActions()
        let heroDeath = SKAction.run({ [weak self] in
            guard let `self` = self else { return }
            self.hero.zRotation = CGFloat(-90).degreesToRadians()
        })
        hero.run(heroDeath)
        resetButton.state = .Active
        let currentScore = Int(scoreLabel.text ?? "")
        if currentScore ?? 0 > previousScore {
            UserDefaults.standard.set(currentScore ?? 0, forKey: R.string.localizable.previousScore())
            let storyboard = UIStoryboard(name: "ScoreScreenTemplate", bundle: nil)
            let scoreScreenVC = storyboard.instantiateViewController(withIdentifier: "scoreVC")
            scoreScreenVC.modalPresentationStyle = .custom
            scoreScreenVC.modalTransitionStyle = .crossDissolve
            view?.window?.rootViewController?.present(scoreScreenVC, animated: true)
        }
    }
}
