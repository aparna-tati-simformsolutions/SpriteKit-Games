//
//  FlappyRabitViewController.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 14/02/23.
//

import UIKit
import SpriteKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigateToGame()
    }
    
    private func navigateToGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let `self` = self else { return }
            let storyboard = UIStoryboard(name: "FlappyRabit", bundle: .main)
            let flappyRabitVC = storyboard.instantiateViewController(withIdentifier: "FlappyRabitViewController")
            self.navigationController?.pushViewController(flappyRabitVC, animated: true)
        }
    }
}
