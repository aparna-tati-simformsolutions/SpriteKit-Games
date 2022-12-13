//
//  SuperMarioViewController.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import UIKit
import SpriteKit

class SuperMarioViewController: UIViewController {

    // MARK: - Variable Declrations & Initialization
    var scene: MarioScene!
    
    // MARK: - View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateToLandscapeLeft()
        presentGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rotateToPortait()
    }
}

extension SuperMarioViewController {
    
    private func presentGame() {
        scene = MarioScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        if let skView = view as? SKView {
            skView.presentScene(scene)
        }
    }
    
    private func rotateToLandscapeLeft() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscapeLeft
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: R.string.localizable.orientation())
        SKView.setAnimationsEnabled(true)
    }
    
    private func rotateToPortait() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: R.string.localizable.orientation())
        SKView.setAnimationsEnabled(true)
    }
}
