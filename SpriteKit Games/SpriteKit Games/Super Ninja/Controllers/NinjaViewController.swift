//
//  NinjaViewController.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 20/02/23.
//

import UIKit
import SpriteKit

class NinjaViewController: UIViewController {
    
    // MARK: - View Controller life cycle methods
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

// MARK: - NinjaViewController extension & its methods
extension NinjaViewController {
    
    private func presentGame() {
        let mainMenuScene = MainMenu(size: CGSize(width: view.frame.size.width, height: 300))
        mainMenuScene.scaleMode = .aspectFill
        if let sKView = view as? SKView {
            sKView.presentScene(mainMenuScene)
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
