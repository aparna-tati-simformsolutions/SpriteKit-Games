//
//  NinjaScene.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 20/02/23.
//

import SpriteKit

class NinjaScene: SKScene {
    
    // MARK: - Variable Declartions & Initilizations
    var ground: SKSpriteNode!
    var player: SKSpriteNode!
    var cameraNode = SKCameraNode()
    var cameraMovePointPerSecond: CGFloat = 150.0
    var lastUpdatedTime: TimeInterval = 0.0
    var dt: TimeInterval = 0.0
    var obstacles: [SKSpriteNode] = []
    var isTime: CGFloat = 3.0
    var onGround: Bool = true
    var velocityY: CGFloat = 0.0
    var gravity: CGFloat = 0.6
    var playerPosY: CGFloat = 0.0
    var coin: SKSpriteNode!
    var score: Int = 0
    var gameOver: Bool = false
    var life: Int = 3
    var lifeNodes: [SKSpriteNode] = []
    var scoreLbl = SKLabelNode(fontNamed: R.font.robotoBlack.name)
    var coinIcon: SKSpriteNode!
    var pauseNode: SKSpriteNode!
    var containerNode = SKNode()
    var soundCoin: SKAction!
    var soundJump: SKAction!
    var soundCollision: SKAction!
    var scoreGenerator = ScoreGenerator()
    var playableRect: CGRect {
        let ratio: CGFloat
        switch UIScreen.main.nativeBounds.height {
        case 2688, 1792, 2436:
            ratio = 2.16
        default:
            ratio = 16/9
        }
        let playableHeight = size.width / ratio
        let playableMargin = (size.height - playableHeight) / 2.0
        return CGRect(x: 0.0, y: playableMargin, width: size.width, height: playableHeight)
    }
    var cameraRect: CGRect {
        let width = playableRect.width
        let height = playableRect.height
        let x = cameraNode.position.x - size.width/2.0 + (size.width - width)/2.0
        let y = cameraNode.position.y - size.height/2.0 + (size.height - height)/2.0
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    // MARK: - Overridden Methods
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setUpNodes()
        SKTAudio.sharedInstance().playBackgroundMusicOf("backgroundMusic.mp3")
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if lastUpdatedTime > 0 {
             dt = currentTime - lastUpdatedTime
        } else {
            dt = 0
        }
        lastUpdatedTime = currentTime
        moveCamera()
        movePlayer()
        
        velocityY += gravity
        player.position.y -= velocityY
        
        if player.position.y < playerPosY {
            player.position.y = playerPosY
            velocityY = 0.0
            onGround = true
        }
        
        if gameOver {
            let gameOverScene = GameOver(size: size)
            gameOverScene.scaleMode = scaleMode
            view?.presentScene(gameOverScene, transition: .doorsOpenVertical(withDuration: 0.5))
        }
        boundCheckPlayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let node = atPoint(touch.location(in: self))
        if node.name == R.string.localizable.pause() {
            if isPaused { return }
            createPanel()
            lastUpdatedTime = 0.0
            dt = 0.0
            isPaused = true
        } else if node.name == R.string.localizable.resume() {
            containerNode.removeFromParent()
            isPaused = false
        } else if node.name == R.string.localizable.quit() {
            let mainMenuScene = MainMenu(size: size)
            mainMenuScene.scaleMode = scaleMode
            view?.presentScene(mainMenuScene, transition: .doorsCloseVertical(withDuration: 0.8))
        } else {
            if !isPaused {
                if onGround {
                    onGround = false
                    velocityY = -13.0
//                    run(soundJump)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if velocityY < -12.5 {
            velocityY = -12.5
        }
    }
    
    deinit {
        SKTAudio.sharedInstance().stopBackgroundMusic()
    }
}

// MARK: - NinjaScene Extension & its methods
extension NinjaScene {
    
    private func setUpNodes() {
        setupPhysics()
        setupAudio()
        setupBackground()
        setupMovingGround()
        setupPlayer()
        setupCamera()
        setupObstacles()
        spawnObstacles()
        setupCoins()
        spawnCoins()
        setupLife()
        setupScore()
        setupPause()
    }
    
    private func setupPhysics() {
        physicsWorld.contactDelegate = self
    }
    
    private func setupAudio() {
//        soundCoin = SKAction.playSoundFileOf(R.file.coinMp3.name)
//        soundJump = SKAction.playSoundFileOf(R.file.jumpWav.name)
//        soundCollision = SKAction.playSoundFileOf(R.file.collisionWav.name)
    }
    
    private func setupBackground() {
        for i in 0...2 {
            let backgroundNode = SKSpriteNode(imageNamed: R.image.ninjaBackground.name)
            backgroundNode.name = R.string.localizable.ninjaBackground()
            backgroundNode.anchorPoint = .zero
            backgroundNode.position = CGPoint(x: CGFloat(i)*backgroundNode.frame.width, y: 0.0)
            backgroundNode.zPosition = -1.0
            addChild(backgroundNode)
        }
    }
    
    private func setupMovingGround() {
        for i in 0...2 {
            ground = SKSpriteNode(imageNamed: R.image.ground.name)
            ground.size = CGSize(width: size.width, height: 100)
            ground.name = R.string.localizable.ninjaGround()
            ground.zPosition = 1.0
            ground.anchorPoint = .zero
            ground.position = CGPoint(x: CGFloat(i)*ground.frame.width, y: 0.0)
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.affectedByGravity = false
            ground.physicsBody?.categoryBitMask = NinjaPhysicsCategory.Ground
            addChild(ground)
        }
    }
    
    private func setupPlayer() {
        player = SKSpriteNode(imageNamed: R.image.ninjaball.name)
        player.size = CGSize(width: 40, height: 40)
        player.name = R.string.localizable.ninjaPlayer()
        player.zPosition = 5.0
        player.setScale(0.85)
        player.position = CGPoint(x: frame.width/2.0 - 100.0, y: ground.frame.height + player.frame.height/2.0)
        playerPosY = player.position.y
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2.0)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.restitution = 0.0
        player.physicsBody?.categoryBitMask = NinjaPhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = NinjaPhysicsCategory.Block | NinjaPhysicsCategory.Player | NinjaPhysicsCategory.Coin
        addChild(player)
    }
    
    private func setupCamera() {
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
    }
    
    private func moveCamera() {
        let amountToMove = CGPoint(x: cameraMovePointPerSecond * CGFloat(dt), y: 0.0)
        cameraNode.position += amountToMove
        
        // BACKGROUND
        enumerateChildNodes(withName: R.string.localizable.ninjaBackground()) { node, _ in
            let node = node as! SKSpriteNode
            if node.position.x + node.frame.width < self.cameraRect.origin.x {
                node.position = CGPoint(x: node.position.x + node.frame.width*2.0, y: node.position.y)
            }
        }
        
        // GROUND
        enumerateChildNodes(withName: R.string.localizable.ninjaGround()) { node, _ in
            let node = node as! SKSpriteNode
            if node.position.x + node.frame.width < self.cameraRect.origin.x {
                node.position = CGPoint(x: node.position.x + node.frame.width*2.0, y: node.position.y)
            }
        }
    }
    
    private func movePlayer() {
        let amountToMove = cameraMovePointPerSecond * CGFloat(dt)
        let rotate = CGFloat(1).degreesToRadians() * amountToMove/2.5
        player.zRotation -= rotate
        player.position.x += amountToMove
    }
    
    private func setupObstacles() {
        for i in 1...3 {
            let sprite = SKSpriteNode(imageNamed: "block-\(i)")
            sprite.name = R.string.localizable.block()
            obstacles.append(sprite)
        }
        
        for i in 1...2 {
            let sprite = SKSpriteNode(imageNamed: "obstacle-\(i)")
            sprite.name = R.string.localizable.ninjaObstacle()
            obstacles.append(sprite)
        }
        
        let index = Int(arc4random_uniform(UInt32(obstacles.count-1)))
        let sprite = obstacles[index].copy() as! SKSpriteNode
        sprite.size = CGSize(width: 50, height: 70)
        sprite.zPosition = 5.0
        sprite.setScale(0.85)
        sprite.position = CGPoint(x: cameraRect.maxX + sprite.frame.width/2.0, y: ground.frame.height + sprite.frame.height/2.0)
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.isDynamic = false
        if sprite.name == R.string.localizable.block() {
            sprite.physicsBody?.categoryBitMask = NinjaPhysicsCategory.Block
        } else {
            sprite.physicsBody?.categoryBitMask = NinjaPhysicsCategory.Obstacle
        }
        sprite.physicsBody?.contactTestBitMask = NinjaPhysicsCategory.Player
        addChild(sprite)
        sprite.run(.sequence([
            .wait(forDuration: 5),
            .removeFromParent()
        ]))
    }
    
    private func spawnObstacles() {
        let random = Double.random(in: 1...3)
        run(.repeatForever(.sequence([
            .wait(forDuration: random),
            .run { [weak self] in
                guard let `self` = self else { return }
                self.setupObstacles()
            }
        ])))
        
        run(.repeatForever(.sequence([
            .wait(forDuration: 5),
            .run({
                self.isTime -= 0.01
                if self.isTime <= 1.5 {
                    self.isTime = 1.5
                }
            })
        ])))
    }
    
    private func setupCoins() {
        coin = SKSpriteNode(imageNamed: R.image.coin1.name)
        coin.name = R.string.localizable.coin()
        coin.zPosition = 20.0
        coin.setScale(0.85)
        coin.size = CGSize(width: 20, height: 20)
        let coinHeight = coin.frame.height
        let random = CGFloat.random(min: -coinHeight, max: coinHeight*2.0)
        coin.position = CGPoint(x: cameraRect.maxX + coin.frame.width / random, y: size.height/2.0 + coin.frame.height)
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.width / 2)
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.categoryBitMask = NinjaPhysicsCategory.Coin
        coin.physicsBody?.contactTestBitMask = NinjaPhysicsCategory.Player
        addChild(coin)
        coin.run(.sequence([.wait(forDuration: 15), .removeFromParent()]))
        
        var textures: [SKTexture] = []
        for i in 1...6 {
            textures.append(SKTexture(imageNamed: "coin-\(i)"))
        }
        coin.run(.repeatForever(.animate(with: textures, timePerFrame: 0.083)))
    }
    
    private func spawnCoins() {
        let random = Double.random(in: 1...4)
        run(.repeatForever(.sequence([
            .wait(forDuration: TimeInterval(random)),
            .run { [weak self] in
                guard let `self` = self else { return }
                self.setupCoins()
            }
        ])))
    }
    
    private func setupLife() {
        let node1 = SKSpriteNode(imageNamed: R.image.lifeOn.name)
        let node2 = SKSpriteNode(imageNamed: R.image.lifeOn.name)
        let node3 = SKSpriteNode(imageNamed: R.image.lifeOn.name)
        setupLifePos(node: node1, i: 1.0, j: 0.0)
        setupLifePos(node: node2, i: 2.0, j: 8.0)
        setupLifePos(node: node3, i: 3.0, j: 16.0)
        lifeNodes.append(node1)
        lifeNodes.append(node2)
        lifeNodes.append(node3)
    }
    
    private func setupLifePos(node: SKSpriteNode, i: CGFloat, j: CGFloat) {
        let width = playableRect.width
        let height = playableRect.height
    
        node.size = CGSize(width: 20, height: 20)
        node.setScale(0.5)
        node.zPosition = 50.0

        node.position = CGPoint(x: -width/2.0 + node.frame.width * i + j, y: height/2.0 - node.frame.height/2.0 - 30)
        cameraNode.addChild(node)
    }
    
    private func setupScore() {
        coinIcon = SKSpriteNode(imageNamed: R.image.coin1.name)
        coinIcon.setScale(0.5)
        coinIcon.zPosition = 50.0
        coinIcon.size = CGSize(width: 15, height: 15)
        coinIcon.position = CGPoint(x: -playableRect.width/2 + coinIcon.frame.width, y: coinIcon.frame.height/2.0 - coinIcon.frame.height/2.0 - lifeNodes[0].frame.height + 70)
        cameraNode.addChild(coinIcon)
        
        scoreLbl.text = "\(score)"
        coinIcon.setScale(0.5)
        scoreLbl.fontSize = 14
        scoreLbl.zPosition = 50.0
        scoreLbl.position = CGPoint(x: -playableRect.width/2 + coinIcon.frame.width * 2.0, y: coinIcon.frame.height/2.0 - coinIcon.frame.height/2.0 - lifeNodes[0].frame.height + 63)
        cameraNode.addChild(scoreLbl)
    }
    
    private func setupGameOver() {
        life -= 1
        if life <= 0 { life = 0 }
        lifeNodes[life].texture = SKTexture(imageNamed: R.image.lifeOff.name)
        
        if life <= 0  && !gameOver {
            gameOver = true
        }
    }
    
    private func setupPause() {
        pauseNode = SKSpriteNode(imageNamed: R.image.pause.name)
        pauseNode.size = CGSize(width: 30, height: 30)
        pauseNode.setScale(0.5)
        pauseNode.zPosition = 60.0
        pauseNode.name = R.string.localizable.pause()
        pauseNode.position = CGPoint(x: playableRect.width/2.0 - 20, y: pauseNode.frame.height/2.0 - pauseNode.frame.width/2.0 - lifeNodes[0].frame.height + 80)
        cameraNode.addChild(pauseNode)
    }
    
    private func createPanel() {
        cameraNode.addChild(containerNode)
        let panel = SKSpriteNode(imageNamed: R.image.panel.name)
        panel.zPosition = 50.0
        panel.size = CGSize(width: 100, height: 50)
        panel.position = .zero
        containerNode.addChild(panel)
        
        let resume = SKSpriteNode(imageNamed: R.image.resume.name)
        resume.zPosition = 70.0
        resume.size = CGSize(width: 20, height: 20)
        resume.name = R.string.localizable.resume()
        resume.setScale(0.7)
        resume.position = CGPoint(x: -panel.frame.width/2.0 + resume.frame.width*1.5, y: 0.0)
        panel.addChild(resume)
        
        let quit = SKSpriteNode(imageNamed: R.image.back.name)
        quit.size = CGSize(width: 20, height: 20)
        quit.zPosition = 70.0
        quit.name = R.string.localizable.quit()
        quit.setScale(0.7)
        quit.position = CGPoint(x: panel.frame.width/2.0 - quit.frame.width*1.5, y: 0.0)
        panel.addChild(quit)
    }
    
    private func boundCheckPlayer() {
        let bottomLeft = CGPoint(x: cameraRect.midX, y: cameraRect.midY)
        if player.position.x <= bottomLeft.x {
            player.position.x = bottomLeft.x
            if life <= 0 {
                gameOver = true
                lifeNodes.forEach({ $0.texture = SKTexture(imageNamed: R.image.lifeOff.name )})
                score = 0
                scoreLbl.text = "\(score)"
            }
        }
    }
}

// MARK: - NinjaScene extension which extendsn SKPhysicsContactDelegate
extension NinjaScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == NinjaPhysicsCategory.Player ? contact.bodyB : contact.bodyA
        switch other.categoryBitMask {
        case NinjaPhysicsCategory.Block:
            cameraMovePointPerSecond += 5.0
            score -= 1
            if score <= 0 { score = 0 }
            scoreLbl.text = "\(score)"
//            run(soundCollision)
        case NinjaPhysicsCategory.Obstacle:
            setupGameOver()
        case NinjaPhysicsCategory.Coin:
            if let node = other.node {
                node.removeFromParent()
                score += 1
                scoreLbl.text = "\(score)"
                if score % 5 == 0 {
                    cameraMovePointPerSecond += 5.0
                }
                
                let highScore = scoreGenerator.getHighScore(Keys.skeyHighScore)
                if score > highScore {
                    scoreGenerator.setHighScore(score, Keys.skeyHighScore)
                    scoreGenerator.setScore(score, Keys.skeyScore)
                }
//                run(soundCoin)
            }
        default:
            break
        }
    }
    
}
