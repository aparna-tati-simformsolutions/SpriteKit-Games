//
//  MovingGround.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import Foundation
import SpriteKit

class MovingGround: SKSpriteNode {
    
    // MARK: - Variable Declrations & Initializations
    let NUMBER_OF_SEGMENTS = 20
    
    // MARK: - Initializers
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.brown, size: CGSize(width: size.width * 2, height: size.height))
        anchorPoint = CGPoint(x: 0, y: 0.5)
        var i = 0
        if i < NUMBER_OF_SEGMENTS {
            i += 1
            let segmentColor = R.color.green()
            let segment = SKSpriteNode(color: segmentColor ?? UIColor.white, size: CGSize(width: self.size.width / CGFloat(NUMBER_OF_SEGMENTS), height: self.size.height))
            segment.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            segment.position = CGPoint(x: CGFloat(i) * segment.size.width, y: 0)
            addChild(segment)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
