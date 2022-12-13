//
//  FlappyRabitViewController.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 15/02/23.
//

import UIKit
import SpriteKit

class FlappyRabitViewController: UIViewController {

    @IBOutlet weak var btnPlay: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(navigateToMainVC))
        navigationItem.backBarButtonItem = backButton
    }
    
    @objc func navigateToMainVC() {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func playButtonClicked(_ sender: UIButton) {
        btnPlay.isHidden = true
        if let view = self.view as? SKView {
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
