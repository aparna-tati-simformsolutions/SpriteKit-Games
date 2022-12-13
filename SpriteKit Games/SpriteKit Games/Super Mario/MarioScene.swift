//
//  MarioScene.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import SpriteKit
import GameplayKit

class MarioScene: SKScene {
    
    var movingGround: MovingGround!
    var cloudGenerator: CloudGenerator!
    var marioHero: MarioHero!
    var pointsLabel: PointsLabel!
    var wallGenerator: WallGenerator!
    var lionGenerator: LionGenerator!
    var treeGenerator: TreeGenerator!
    var isStarted = false
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1)
        addMovingGround()
        addMarioHero()
        addCloudGenerator()
        addWallGenerator()
        addTapToStartLabel()
        addPointsLabel()
        addPhysicsWorld()
        loadHighScore()
        addLionGenerator()
        addTreeGenerator()
    }
    
    func addMovingGround() {
        movingGround = MovingGround(size: CGSize(width: view?.frame.width ?? 0, height: kGroundHeight))
        movingGround.position = CGPoint(x: 0, y: (view?.frame.size.height ?? 0)/2)
        addChild(movingGround)
    }
    
    func addMarioHero() {
        marioHero = MarioHero()
        marioHero.position = CGPoint(x: 70, y: Int(movingGround.position.y) +                                                                                       Int(movingGround.frame.size.height/2) +
                                               Int(marioHero.frame.size.height/2))
        addChild(marioHero)
        marioHero.breathe()
    }
    
    func addCloudGenerator() {
        cloudGenerator = CloudGenerator(color: UIColor.clear, size: view?.frame.size ?? CGSize(width: 0, height: 0))
        cloudGenerator.position = view?.center ?? CGPoint(x: 0.0, y: 0.0)
        addChild(cloudGenerator)
        cloudGenerator.populate(num: 7)
        cloudGenerator.startGeneratingWithSpawnTime(seconds: 3)
    }
    
    func addTapToStartLabel() {
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
    
    func addPointsLabel() {
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
    
    func addPhysicsWorld() {
        physicsWorld.contactDelegate = self
    }
    
    func loadHighScore() {
        let defaults = UserDefaults.standard
        let highScoreLabel = childNode(withName: R.string.localizable.highScoreLabelName()) as! PointsLabel
        highScoreLabel.setTo(num: defaults.integer(forKey: R.string.localizable.highScore()))
    }
    
    func addWallGenerator() {
        wallGenerator = WallGenerator(color: UIColor.clear, size: view?.frame.size ?? CGSize(width: 0, height: 0))
        wallGenerator.position = view?.center ?? CGPoint(x: 0.0, y: 0.0)
        addChild(wallGenerator)
    }
    
    func addLionGenerator() {
        lionGenerator = LionGenerator(color: UIColor.clear, size: view?.frame.size ?? CGSize(width: 0, height: 0))
        lionGenerator.position = view?.center ?? CGPoint(x: 0.0, y: 0.0)
        addChild(lionGenerator)
    }
    
    func addTreeGenerator() {
        treeGenerator = TreeGenerator(color: UIColor.clear, size: view?.frame.size ?? CGSize(width: 0, height: 0))
        treeGenerator.position = view?.center ?? CGPoint(x: 0.0, y: 0.0)
        addChild(treeGenerator)
    }
    
    func blinkAnimation() -> SKAction {
        let duration = 0.4
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: duration)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatForever(blink)
    }
    
    func start() {
        isStarted = true
        let tapToStartLabel = childNode(withName: R.string.localizable.tapToStartLabelName())
        tapToStartLabel?.removeFromParent()
        
        marioHero.stop()
        movingGround.start()
        marioHero.startRunning()
        
        lionGenerator.startGeneratingLionsEvery(seconds: 2.5)
        wallGenerator.startGeneratingWallsEvery(seconds: 1)
        treeGenerator.startGeneratingTreesEvery(seconds: 3)
    }
    
    func gameOver() {
        isGameOver = true
        
        marioHero.fall()
        wallGenerator.stopWalls()
        lionGenerator.stopLions()
        treeGenerator.stopTrees()
        movingGround.stop()
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
    
    func restart() {
        cloudGenerator.stopGenerating()
               
        let newScene = MarioScene(size: view!.bounds.size)
        newScene.scaleMode = .aspectFill
        view!.presentScene(newScene)
    }
}

extension MarioScene: SKPhysicsContactDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            restart()
        } else if !isStarted {
            start()
        } else {
            marioHero.flip()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if wallGenerator.wallTrackers.count > 0 {
            let wall = wallGenerator.wallTrackers[0] as Wall
            let wallLocation = wallGenerator.convert(wall.position, to: self)
            if wallLocation.x < marioHero.position.x {
                wallGenerator.wallTrackers.remove(at: 0)
                let pointsLabel = childNode(withName: R.string.localizable.pointsLabelName()) as! PointsLabel
                pointsLabel.increment()
            }
        }
               
        if lionGenerator.lionTrackers.count > 0 {
            let wall = lionGenerator.lionTrackers[0] as Lion
            let wallLocation = lionGenerator.convert(wall.position, to: self)
            if wallLocation.x < marioHero.position.x {
                lionGenerator.lionTrackers.remove(at: 0)
                let pointsLabel = childNode(withName: R.string.localizable.pointsLabelName()) as! PointsLabel
                pointsLabel.increment()
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
                
        if (firstBody.categoryBitMask == heroCategory) &&
            (secondBody.categoryBitMask == treeCategory) {
                treeGenerator.removeFromParent()
        } else {
            if !isGameOver {
                gameOver()
            }
        }
    }
}
