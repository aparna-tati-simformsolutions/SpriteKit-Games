//
//  CustomButton.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 15/12/22.
//

import SpriteKit

enum ButtonState {
    case Selected, Active, Hidden
}

class CustomButton: SKSpriteNode {
    var selectedHandler: () -> Void = { print("No button action set") }

    var state: ButtonState = .Active {
        didSet {
            switch state {
            case .Active:
                self.isUserInteractionEnabled = true
                self.alpha = 1
                break
            case .Hidden:
                self.isUserInteractionEnabled = false
                self.alpha = 0
                break
            case .Selected:
                self.alpha = 0.7
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .Selected
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedHandler()
        state = .Active
    }
}
