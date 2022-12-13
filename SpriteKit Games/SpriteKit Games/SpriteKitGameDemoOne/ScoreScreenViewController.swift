//
//  ScoreScreenViewController.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 26/12/22.
//

import UIKit
import SpriteKit

class ScoreScreenViewController: UIViewController {

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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scoreScreenVC = storyboard.instantiateViewController(withIdentifier: "GameViewController")
        navigationController?.pushViewController(scoreScreenVC, animated: true)
    }
}
