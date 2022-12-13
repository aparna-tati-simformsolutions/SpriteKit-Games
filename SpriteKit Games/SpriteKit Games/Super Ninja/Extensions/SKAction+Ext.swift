//
//  SKAction+Ext.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 23/02/23.
//

import SpriteKit

// MARK: - SKAction Extension
extension SKAction {
    
    class func playSoundFileOf(_ fileNamed: String) -> SKAction {
        if !effectEnabled { return SKAction() }
        return SKAction.playSoundFileNamed(fileNamed, waitForCompletion: false)
    }
}

// MARK: - Stored Properties
private let keyEffect = R.string.localizable.keyEffect()
var effectEnabled: Bool = {
    return !UserDefaults.standard.bool(forKey: keyEffect)
}() {
    didSet {
        let value = !effectEnabled
        UserDefaults.standard.set(value, forKey: keyEffect)
        if value {
            SKAction.stop()
        }
    }
}
