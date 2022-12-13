//
//  TreeGenerator.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import SpriteKit

class TreeGenerator: SKSpriteNode {
    
    var generationTimer: Timer!
    var trees = [Tree]()
    var treeTrackers = [Tree]()
    
    func startGeneratingTreesEvery(seconds: TimeInterval) {
        generationTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(generateTree), userInfo: nil, repeats: true)
    }
    
    func stopGeneratingTrees() {
        generationTimer.invalidate()
    }
    
    @objc func generateTree() {
        var scale: CGFloat
        let random = arc4random_uniform(2)
        if random == 0 {
            scale = 1.0
        } else {
            scale = 1.0
        }
        
        let tree = Tree()
        tree.position.x = size.width / 2 + tree.size.width / 2
        tree.position.y = scale * (kGroundHeight / 2 + tree.size.height / 2)
        trees.append(tree)
        treeTrackers.append(tree)
        addChild(tree)
    }
    
    func stopTrees() {
        stopGeneratingTrees()
        for tree in trees {
            tree.stopMoving()
        }
    }
    
}

