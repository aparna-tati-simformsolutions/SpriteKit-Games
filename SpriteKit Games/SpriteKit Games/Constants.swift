//
//  Constants.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import Foundation

let kDefaultXToMovePerSecond: CGFloat = 320.0
let kGroundHeight: CGFloat = 20.0

// Collision Detection
let heroCategory: UInt32 = 0x1 << 0
let enemyCategory: UInt32 = 0x1 << 1
let treeCategory: UInt32 = 0x1 << 2

struct MarioPhysicsCategory {
    static let heroCategory: UInt32 = 0b0   // 0
    static let enemyCategory: UInt32 = 0b1  // 1
    static let treeCategory: UInt32 = 0b10  // 2
}

struct NinjaPhysicsCategory {
    static let Player: UInt32 = 0b1      // 1
    static let Block: UInt32 = 0b10      // 2
    static let Obstacle: UInt32 = 0b100  // 4
    static let Ground: UInt32 = 0b1000   // 8
    static let Coin: UInt32 = 0b10000    // 16
}

struct Keys {
    static let skeyHighScore = R.string.localizable.sKeyHighScore()
    static let skeyScore = R.string.localizable.sKeyScore()
    
    static let fkeyHighScore = R.string.localizable.fKeyHighScore()
    static let fkeyScore = R.string.localizable.fScore()
}
