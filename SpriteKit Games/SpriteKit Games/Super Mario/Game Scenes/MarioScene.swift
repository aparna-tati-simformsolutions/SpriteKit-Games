//
//  MarioScene.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import SpriteKit
import GameplayKit

class MarioScene: SKScene {
    
    // MARK: - Variable Declrations & Initializations
    var movingGround: MovingGround!
    var cloudGenerator: CloudGenerator!
    var marioHero: MarioHero!
    var pointsLabel: PointsLabel!
    var enemyGenerator: EnemyGenerator!
    var isStarted = false
    var isGameOver = false
    
    // MARK: - Overridden Methods
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if isGameOver {
            restart()
        } else if !isStarted {
            start()
        } else {
            marioHero.flip()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if enemyGenerator.wallTrackers.count > 0 {
            let wall = enemyGenerator.wallTrackers[0] as Wall
            let wallPosition = enemyGenerator.convert(wall.position, to: self)
            if wallPosition.x < marioHero.position.x {
                enemyGenerator.wallTrackers.remove(at: 0)
                let pointsLabel = childNode(withName: R.string.localizable.pointsLabelName()) as! PointsLabel
                pointsLabel.increment()
            }
        }
        
        if enemyGenerator.lionTrackers.count > 0 {
            let lion = enemyGenerator.lionTrackers[0] as Lion
            let lionPosition = enemyGenerator.convert(lion.position, to: self)
            if lionPosition.x < marioHero.position.x {
                enemyGenerator.lionTrackers.remove(at: 0)
                let pointsLabel = childNode(withName: R.string.localizable.pointsLabelName()) as! PointsLabel
                pointsLabel.increment()
            }
        }
    }
}

// MARK: - Mario Scene Extends SKPhysicsContactDelegate
extension MarioScene: SKPhysicsContactDelegate {
  
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
                
        if (firstBody.categoryBitMask == MarioPhysicsCategory.heroCategory) &&
            (secondBody.categoryBitMask == MarioPhysicsCategory.treeCategory) {
            enemyGenerator.removeFromParent()
        } else {
            if !isGameOver {
                gameOver()
            }
        }
    }
}

// MARK: - Mario Scene Extension & its Methods
extension MarioScene {
    
    private func setupNodes() {
        backgroundColor = R.color.sky() ?? UIColor.white
        addMovingGround()
        addMarioHero()
        addCloudGenerator()
        addWallGenerator()
        addTapToStartLabel()
        addPointsLabel()
        addPhysicsWorld()
        loadHighScore()
    }
    
    private func addMovingGround() {
        movingGround = MovingGround(size: CGSize(width: view?.frame.width ?? 0, height: kGroundHeight))
        movingGround.position = CGPoint(x: 0, y: (view?.frame.size.height ?? 0) / 2)
        addChild(movingGround)
    }
    
    private func addMarioHero() {
        marioHero = MarioHero()
        marioHero.position = CGPoint(x: 70, y: Int(movingGround.position.y) +                                                                                          Int(movingGround.frame.size.height / 2 ) +
                                               Int(marioHero.frame.size.height / 2))
        addChild(marioHero)
        marioHero.breathe()
    }
    
    private func addCloudGenerator() {
        cloudGenerator = CloudGenerator(color: UIColor.clear, size: view?.frame.size ?? CGSize(width: 0, height: 0))
        cloudGenerator.position = view?.center ?? CGPoint(x: 0.0, y: 0.0)
        addChild(cloudGenerator)
        cloudGenerator.populate(num: 7)
        cloudGenerator.startGeneratingWithSpawnTime(seconds: 3)
    }
    
    private func addWallGenerator() {
        enemyGenerator = EnemyGenerator(color: UIColor.clear, size: view?.frame.size ?? CGSize(width: 0, height: 0))
        enemyGenerator.position = view?.center ?? CGPoint(x: 0.0, y: 0.0)
        addChild(enemyGenerator)
    }
    
    private func addTapToStartLabel() {
        let tapToStartLabel = SKLabelNode(text: R.string.localizable.taptostart())
        tapToStartLabel.name = R.string.localizable.tapToStartLabelName()
        tapToStartLabel.position.x = view?.center.x ?? 0.0
        tapToStartLabel.position.y = view?.center.y ?? 0.0 + 40
        tapToStartLabel.fontName = R.font.robotoBlackItalic.name
        tapToStartLabel.fontColor = UIColor.black
        tapToStartLabel.fontSize = 22.0
        addChild(tapToStartLabel)
        tapToStartLabel.run(blinkAnimation())
    }
    
    private func addPointsLabel() {
        pointsLabel = PointsLabel(num: 0)
        pointsLabel.position = CGPoint(x: 20.0, y: (self.size.height / 2) + 70)
        pointsLabel.name = R.string.localizable.pointsLabelName()
        addChild(pointsLabel)
        
        let highScoreLabel = PointsLabel(num: 0)
        highScoreLabel.position = CGPoint(x: (view?.frame.size.width ?? 0.0) - 20, y: (self.size.height / 2) + 70)
        highScoreLabel.name = R.string.localizable.highScoreLabelName()
        addChild(highScoreLabel)
        
        let highScoreTextLabel = SKLabelNode(text: R.string.localizable.high())
        highScoreTextLabel.position = CGPoint(x: 0, y: -20)
        highScoreTextLabel.fontColor = UIColor.black
        highScoreTextLabel.fontSize = 14.0
        highScoreTextLabel.fontName = R.font.robotoBlack.name
        highScoreLabel.addChild(highScoreTextLabel)
    }
    
    private func addPhysicsWorld() {
        physicsWorld.contactDelegate = self
    }
    
    private func loadHighScore() {
        let defaults = UserDefaults.standard
        let highScoreLabel = childNode(withName: R.string.localizable.highScoreLabelName()) as! PointsLabel
        highScoreLabel.setTo(num: defaults.integer(forKey: R.string.localizable.highScore()))
    }
    
    private func blinkAnimation() -> SKAction {
        let duration = 0.4
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: duration)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatForever(blink)
    }
    
    private func start() {
        isStarted = true
        
        let tapToStartLabel = childNode(withName: R.string.localizable.tapToStartLabelName())
        tapToStartLabel?.removeFromParent()
        
        marioHero.stop()
        marioHero.startRunning()
       
        enemyGenerator.startGeneratingEnemyEvery(seconds: 1)
    }
    
    private func gameOver() {
        isGameOver = true
        
        marioHero.fall()
        enemyGenerator.stopMovingEnemies()
        marioHero.stop()
        
        let gameOverLabel = SKLabelNode(text: R.string.localizable.gameOver())
        gameOverLabel.fontColor = UIColor.black
        gameOverLabel.fontName = R.font.robotoBlack.name
        gameOverLabel.position.x = view?.center.x ?? 0.0
        gameOverLabel.position.y = view?.center.y ?? 0.0 + 40.0
        gameOverLabel.fontSize = 22.0
        addChild(gameOverLabel)
        gameOverLabel.run(blinkAnimation())
        
        let pointsLabel = childNode(withName: R.string.localizable.pointsLabelName()) as! PointsLabel
        let highscoreLabel = childNode(withName: R.string.localizable.highScoreLabelName()) as! PointsLabel
        
        if highscoreLabel.number < pointsLabel.number {
            highscoreLabel.setTo(num: pointsLabel.number)
            let defaults = UserDefaults.standard
            defaults.set(highscoreLabel.number, forKey: R.string.localizable.highScore())
        }
    }
    
    private func restart() {
        cloudGenerator.stopGenerating()
        let newScene = MarioScene(size: view?.bounds.size ?? CGSize(width: 0, height: 0))
        newScene.scaleMode = .aspectFill
        view?.presentScene(newScene)
    }
}
