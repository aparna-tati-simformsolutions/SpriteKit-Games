//
//  FlappyRabitViewController.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 14/02/23.
//

import UIKit
import SpriteKit

class WelcomeViewController: UIViewController {

    // MARK: - View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presentGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Class Methods
    private func presentGame() {
        let welcomeScene = WelcomeScene(size: CGSize(width: view.frame.size.width, height: view.frame.size.height))
        welcomeScene.scaleMode = .aspectFill
        if let skView = view as? SKView {
            skView.presentScene(welcomeScene)
        }
    }
}
