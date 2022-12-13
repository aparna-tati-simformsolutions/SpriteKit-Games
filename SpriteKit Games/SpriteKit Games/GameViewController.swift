//
//  GameViewController.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 13/12/22.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - View Controller Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Action Methods
    @IBAction func ninjaButtonClicked(_ sender: UIButton) {
        navigateToGame(storyboard: UIStoryboard(name: "SuperMario", bundle: .main), identifier: R.storyboard.superMario.superMarioViewController.identifier
        )
    }
    
    @IBAction func flappyButtonClicked(_ sender: UIButton) {
        navigateToGame(storyboard: UIStoryboard(name: "FlappyRabit", bundle: .main), identifier: R.storyboard.flappyRabit.welcomeViewController.identifier)
    }
    
    @IBAction func ninjaGameButtonClicked(_ sender: UIButton) {
        navigateToGame(storyboard: UIStoryboard(name: "Ninja", bundle: .main), identifier: R.storyboard.ninja.ninjaViewController.identifier)
    }
    
    // MARK: - Class Methods
    private func navigateToGame(storyboard: UIStoryboard, identifier: String) {
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
