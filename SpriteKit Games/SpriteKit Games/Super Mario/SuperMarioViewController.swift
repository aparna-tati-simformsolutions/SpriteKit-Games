//
//  SuperMarioViewController.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 16/02/23.
//

import UIKit
import SpriteKit

class SuperMarioViewController: UIViewController {

    var scene: MarioScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateToLandscapeLeft()
        let skView = view as? SKView
        if let skView = skView {
            skView.isMultipleTouchEnabled = true
            scene = MarioScene(size: skView.bounds.size)
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rotateToPortait()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    func rotateToLandscapeLeft() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscapeLeft
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: R.string.localizable.orientation())
        SKView.setAnimationsEnabled(true)
    }
    
    func rotateToPortait() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: R.string.localizable.orientation())
        SKView.setAnimationsEnabled(true)
    }
}
