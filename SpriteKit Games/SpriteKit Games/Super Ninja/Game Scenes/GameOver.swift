//
//  GameOver.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 22/02/23.
//

import SpriteKit

class GameOver: SKScene {
    
    // MARK: - Overridden Methods
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        createBackgroundNodes()
        createGroundNodes()
        createGameOverNode()
        run(.sequence([
            .wait(forDuration: 0.5),
            .run({ [weak self] in
                guard let `self` = self else { return }
                let mainMenuScene = MainMenu(size: self.size)
                mainMenuScene.scaleMode = self.scaleMode
                view.presentScene(mainMenuScene,transition: .doorsOpenVertical(withDuration: 0.8))
            })
        ]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        moveBackgroundAndGroundNodes()
    }
}

// MARK: - GameOver Extension and its methods
extension GameOver {
    
    private func createBackgroundNodes() {
        for i in 0...2 {
            let backgroundNode = SKSpriteNode(imageNamed: R.image.ninjaBackground.name)
            backgroundNode.name = R.string.localizable.ninjaBackground()
            backgroundNode.anchorPoint = .zero
            backgroundNode.position = CGPoint(x: CGFloat(i)*backgroundNode.frame.width, y: 0.0)
            backgroundNode.zPosition = -1.0
            addChild(backgroundNode)
        }
    }
    
    private func createGroundNodes() {
        for i in 0...2 {
            let ground = SKSpriteNode(imageNamed: R.image.ground.name)
            ground.name = R.string.localizable.ninjaGround()
            ground.zPosition = 1.0
            ground.anchorPoint = .zero
            ground.position = CGPoint(x: CGFloat(i)*ground.frame.width, y: 3.0)
            addChild(ground)
        }
    }
    
    private func moveBackgroundAndGroundNodes() {
        // BACKGROND
        enumerateChildNodes(withName: R.string.localizable.ninjaBackground()) { node, _ in
            let node = node as! SKSpriteNode
            node.position.x -= 8.0
            if node.position.x < -self.frame.width {
                node.position.x += node.frame.width*2.0
            }
        }
        
        // GROUND
        enumerateChildNodes(withName: R.string.localizable.ninjaGround()) { node, _ in
            let node = node as! SKSpriteNode
            node.position.x -= 8.0
            if node.position.x < -self.frame.width {
                node.position.x += node.frame.width*2.0
            }
        }
    }
    
    private func createGameOverNode() {
        let gameOver = SKSpriteNode(imageNamed: R.image.gameOver.name)
        gameOver.size = CGSize(width: 300, height: 100)
        gameOver.zPosition = 10.0
        gameOver.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        addChild(gameOver)
        
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let fullScale = SKAction.sequence([scaleUp, scaleDown])
        gameOver.run(.repeatForever(fullScale))
    }
}
