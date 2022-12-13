//
//  GameViewController.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 13/12/22.
//

import UIKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func ninjaButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SuperMario", bundle: .main)
        let flappyRabitVC = storyboard.instantiateViewController(withIdentifier: "SuperMarioViewController")
        navigationController?.pushViewController(flappyRabitVC, animated: true)
    }
    
    @IBAction func flappyButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "FlappyRabit", bundle: .main)
        let flappyRabitVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        navigationController?.pushViewController(flappyRabitVC, animated: true)
    }
    
}
