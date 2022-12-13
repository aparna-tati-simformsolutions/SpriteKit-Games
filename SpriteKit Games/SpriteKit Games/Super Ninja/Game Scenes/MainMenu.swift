//
//  MainMenu.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 22/02/23.
//

import SpriteKit

class MainMenu: SKScene {
    
    // MARK: - Variable Delcrations and Initlizations
    var containerNode: SKSpriteNode!
    var panel: SKSpriteNode!
    var scoreGenerator = ScoreGenerator()
    
    // MARK: - Overridden Methods
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupBackground()
        setupGround()
        setupNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let node = atPoint(touch.location(in: self))
        if node.name == R.string.localizable.play() {
            let ninjaScene = NinjaScene(size: size)
            ninjaScene.scaleMode = scaleMode
            view?.presentScene(ninjaScene, transition: .doorsOpenVertical(withDuration: 0.3))
        } else if node.name == R.string.localizable.highScore() {
            setupHighScorePanel()
        } else if node.name == R.string.localizable.setting() {
            setupSettingPanel()
        } else if node.name == R.string.localizable.container() {
            containerNode.removeFromParent()
        } else if node.name == R.string.localizable.music() {
            let node = node as! SKSpriteNode
            SKTAudio.musicEnabled = !SKTAudio.musicEnabled
            node.texture = SKTexture(imageNamed: SKTAudio.musicEnabled ? R.image.musicOn.name : R.image.musicOff.name)
        } else if node.name == R.string.localizable.effect() {
            let node = node as! SKSpriteNode
            effectEnabled = !effectEnabled
            node.texture = SKTexture(imageNamed: effectEnabled ? R.image.effectOn.name : R.image.effectOff.name)
        } else if node.name == R.string.localizable.quit() {
            panel.removeFromParent()
        }
    }

}

// MARK: - MainMenu Extension and Its methods
extension MainMenu {
    
    private func setupBackground() {
        let backgroundNode = SKSpriteNode(imageNamed: R.image.ninjaBackground.name)
        backgroundNode.name = R.string.localizable.ninjaBackground()
        backgroundNode.anchorPoint = .zero
        backgroundNode.position = .zero
        backgroundNode.zPosition = -1.0
        addChild(backgroundNode)
    }
    
    private func setupGround() {
        let ground = SKSpriteNode(imageNamed: R.image.ground.name)
        ground.size = CGSize(width: size.width, height: 100)
        ground.name = R.string.localizable.ninjaGround()
        ground.zPosition = 1.0
        ground.anchorPoint = .zero
        ground.position = .zero
        addChild(ground)
    }
    
    private func setupNodes() {
        let play = SKSpriteNode(imageNamed: R.image.play.name)
        play.size = CGSize(width: 130, height: 40)
        play.name = R.string.localizable.play()
        play.setScale(0.85)
        play.zPosition = 10.0
        play.position = CGPoint(x: size.width/2.0, y: size.height/2.0 + 50)
        addChild(play)
        
        let highScore = SKSpriteNode(imageNamed: R.image.highscore.name)
        highScore.size = CGSize(width: 130, height: 40)
        highScore.name = R.string.localizable.highScore()
        highScore.setScale(0.85)
        highScore.zPosition = 10.0
        highScore.position = CGPoint(x: size.width/2.0, y: size.height/2.0 + 10)
        addChild(highScore)
        
        let setting = SKSpriteNode(imageNamed: R.image.setting.name)
        setting.size = CGSize(width: 130, height: 40)
        setting.name = R.string.localizable.setting()
        setting.setScale(0.85)
        setting.zPosition = 10.0
        setting.position = CGPoint(x: size.width/2.0, y: size.height/2.0 - 30)
        addChild(setting)
    }
    
    private func setupHighScorePanel() {
        setupContainer()
        
        panel = SKSpriteNode(imageNamed: R.image.panel.name)
        panel.name = R.string.localizable.highScorePanel()
        panel.size = CGSize(width: 100, height: 50)
        panel.setScale(1.5)
        panel.zPosition = 20.0
        panel.position = .zero
        containerNode.addChild(panel)
        
        let x = -panel.frame.width/2.0 + 35
        let highScoreLabel = SKLabelNode(fontNamed: R.font.robotoBlack.name)
        highScoreLabel.text = "HighScore: \(scoreGenerator.getHighScore(Keys.skeyHighScore))"
        highScoreLabel.horizontalAlignmentMode = .left
        highScoreLabel.fontSize = 12
        highScoreLabel.zPosition = 25.0
        highScoreLabel.position = CGPoint(x: x, y: highScoreLabel.frame.height/2.0)
        panel.addChild(highScoreLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: R.font.robotoBlack.name)
        scoreLabel.text = "Score: \(scoreGenerator.getScore(Keys.skeyScore))"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 12
        scoreLabel.zPosition = 25.0
        scoreLabel.position = CGPoint(x: x, y: -scoreLabel.frame.height/2.0)
        panel.addChild(scoreLabel)
        
        let quit = SKSpriteNode(imageNamed: R.image.back.name)
        quit.size = CGSize(width: 20, height: 20)
        quit.zPosition = 70.0
        quit.name = R.string.localizable.quit()
        quit.setScale(0.7)
        quit.position = CGPoint(x: panel.frame.width/2.0 - 70, y: -quit.frame.height/2.0 - 7)
        panel.addChild(quit)
    }
    
    private func setupSettingPanel() {
        setupContainer()
        
        panel = SKSpriteNode(imageNamed: R.image.panel.name)
        panel.name = R.string.localizable.settingPanel()
        panel.size = CGSize(width: 100, height: 70)
        panel.setScale(1.5)
        panel.zPosition = 20.0
        panel.position = .zero
        containerNode.addChild(panel)
        
        let music = SKSpriteNode(imageNamed: SKTAudio.musicEnabled ? R.image.musicOn.name : R.image.musicOff.name)
        music.size = CGSize(width: 40, height: 40)
        music.name = R.string.localizable.music()
        music.setScale(0.7)
        music.zPosition = 20.0
        music.position = CGPoint(x: -panel.frame.width/2.0 + 50, y: -music.frame.height/2.0 + 25)
        panel.addChild(music)
        
        let effect = SKSpriteNode(imageNamed: effectEnabled ? R.image.effectOn.name : R.image.effectOff.name)
        effect.size = CGSize(width: 40, height: 40)
        effect.name = R.string.localizable.effect()
        effect.setScale(0.7)
        effect.zPosition = 25.0
        effect.position = CGPoint(x: panel.frame.width/2.0 - 50, y: -effect.frame.height/2.0 + 25)
        panel.addChild(effect)
        
        let quit = SKSpriteNode(imageNamed: R.image.back.name)
        quit.size = CGSize(width: 40, height: 40)
        quit.zPosition = 70.0
        quit.name = R.string.localizable.quit()
        quit.setScale(0.7)
        quit.position = CGPoint(x: panel.frame.width/2.0 - 75, y: -quit.frame.height/2.0)
        panel.addChild(quit)
    }
    
    private func setupContainer() {
        containerNode = SKSpriteNode()
        containerNode.size = CGSize(width: 200, height: 200)
        containerNode.name = R.string.localizable.container()
        containerNode.color = .clear
        containerNode.zPosition = 15.0
        containerNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        addChild(containerNode)
    }
}
