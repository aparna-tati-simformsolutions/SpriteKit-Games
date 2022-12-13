//
//  PointsLabel.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import UIKit
import SpriteKit

class PointsLabel: SKLabelNode {
    
    var number = 0
    
    init(num: Int) {
        super.init()
        fontColor = UIColor.black
        fontName = R.font.robotoBlack.name
        fontSize = 24.0
        
        number = num
        text = "\(num)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func increment() {
        number += 1
        text = "\(number)"
    }
    
    func setTo(num: Int) {
        self.number = num
        text = "\(self.number)"
    }
}
