//
//  ScoreScreenViewController.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 26/12/22.
//

import UIKit
import SpriteKit

class ScoreViewController: UIViewController {

    @IBOutlet weak var scoreView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonExitTapped(_ sender: UIButton) {
        exit(0)
    }
    
    @IBAction func buttonCloseTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func buttonRestartTapped(_ sender: UIButton) {
        scoreView.isHidden = true
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
    
            if let scene = SKScene(fileNamed: R.string.localizable.bunnyScene()) {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
        }
    }
}
