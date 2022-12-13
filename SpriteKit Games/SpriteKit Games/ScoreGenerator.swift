//
//  ScoreGenerator.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 22/02/23.
//

import Foundation

class ScoreGenerator {

    func setScore(_ score: Int, _ key: String) {
        UserDefaults.standard.set(score, forKey: key)
    }
    
    func getScore(_ key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    func setHighScore(_ highScore: Int, _ key: String) {
        UserDefaults.standard.set(highScore, forKey: key)
    }
    
    func getHighScore(_ key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
}
