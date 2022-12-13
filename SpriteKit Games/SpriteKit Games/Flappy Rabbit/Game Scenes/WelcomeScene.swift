//
//  MainMenu.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 24/02/23.
//

import SpriteKit

class WelcomeScene: SKScene {
    
    // MARK: - Variable Declrations And Initializations
    var containerNode: SKSpriteNode!
    var panel: SKSpriteNode!
    var scoreGenerator = ScoreGenerator()
    
    // MARK: - Overridden Methods
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupNodes()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = self.nodes(at: location)
        for node in nodes {
            if node.name == R.string.localizable.play() {
                let scene = SKScene(fileNamed: R.string.localizable.bunnyScene())
                scene?.scaleMode = .aspectFill
                view?.presentScene(scene)
            } else if node.name == R.string.localizable.highScore() {
                setupHighScorePanel()
            } else if node.name == R.string.localizable.container() {
                panel.removeFromParent()
            }
        }
    }
}

// MARK: - WelcomeScene Extension Methods
extension WelcomeScene {
    
    private func setupNodes() {
        setupTransparentBackgroundImage()
        setupTitleNode()
        setupBackground()
        setupGround()
        setupPlayNode()
    }
    
    private func setupTransparentBackgroundImage() {
        let backgroundIcon = SKSpriteNode(imageNamed: R.image.rabbit.name)
        backgroundIcon.alpha = 0.2
        backgroundIcon.size = CGSize(width: size.width + 100, height: size.height / 2.0)
        backgroundIcon.position = CGPoint(x: 50, y: size.height / 2.0)
        backgroundIcon.zPosition = 5.0
        addChild(backgroundIcon)
    }
    
    private func setupTitleNode() {
        let titleNode = SKLabelNode(text: R.string.localizable.flappyRabbit())
        titleNode.fontSize = 34
        titleNode.color = UIColor.purple
        titleNode.colorBlendFactor = 1
        titleNode.fontName = "Helvetica-Bold"
        titleNode.blendMode = SKBlendMode.multiply
        titleNode.colorBlendFactor = 1.0
        titleNode.position = CGPoint(x: size.width/2, y: size.height/2 + 200)
        titleNode.zPosition = 6.0
        addChild(titleNode)
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: R.image.background.name)
        background.size = CGSize(width: size.width, height: size.height)
        background.position = .zero
        background.anchorPoint = .zero
        background.zPosition = 1.0
        addChild(background)
    }
    
    private func setupGround() {
        let ground = SKSpriteNode(imageNamed: R.image.ground.name)
        ground.position = .zero
        ground.size = CGSize(width: size.width, height: 200)
        ground.anchorPoint = .zero
        ground.zPosition = 2.0
        addChild(ground)
    }
    
    private func setupPlayNode() {
        let playNode = SKSpriteNode(imageNamed: R.image.play.name)
        playNode.name = R.string.localizable.play()
        playNode.size = CGSize(width: 150, height: 50)
        playNode.position = CGPoint(x: size.width / 3.2, y: size.height / 2.0)
        playNode.anchorPoint = .zero
        playNode.zPosition = 7.0
        addChild(playNode)
        
        let highScore = SKSpriteNode(imageNamed: R.image.highscore.name)
        highScore.size = CGSize(width: 150, height: 50)
        highScore.name = R.string.localizable.highScore()
        highScore.anchorPoint = .zero
        highScore.zPosition = 8.0
        highScore.position = CGPoint(x: size.width / 3.2, y: playNode.position.y - 70)
        addChild(highScore)
    }
    
    private func setupHighScorePanel() {
        setupContainer()
        
        panel = SKSpriteNode(imageNamed: R.image.panel.name)
        panel.name = R.string.localizable.highScorePanel()
        panel.size = CGSize(width: 200, height: 100)
        panel.setScale(1.5)
        panel.zPosition = 20.0
        panel.position = .zero
        containerNode.addChild(panel)
        
        let x = -panel.frame.width/2.0 + 65
        let highScoreLabel = SKLabelNode(fontNamed: R.font.robotoBlack.name)
        highScoreLabel.text = "HighScore: \(scoreGenerator.getHighScore(Keys.fkeyHighScore))"
        highScoreLabel.horizontalAlignmentMode = .left
        highScoreLabel.fontSize = 24
        highScoreLabel.zPosition = 25.0
        highScoreLabel.position = CGPoint(x: x, y: highScoreLabel.frame.height/2.0)
        panel.addChild(highScoreLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: R.font.robotoBlack.name)
        scoreLabel.text = "Score: \(scoreGenerator.getScore(Keys.fkeyScore))"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 24
        scoreLabel.zPosition = 25.0
        scoreLabel.position = CGPoint(x: x, y: -scoreLabel.frame.height/2.0)
        panel.addChild(scoreLabel)
    }
    
    private func setupContainer() {
        containerNode = SKSpriteNode()
        containerNode.size = CGSize(width: size.width, height: size.height)
        containerNode.name = R.string.localizable.container()
        containerNode.color = .clear
        containerNode.zPosition = 15.0
        containerNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        addChild(containerNode)
    }
}
