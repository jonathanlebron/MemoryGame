//
//  LobbyViewController.swift
//  Memory Game
//
//  Created by JL on 3/19/19.
//  Copyright © 2019 JL. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {
    @IBOutlet weak var optionsStackView: UIStackView!
    let options: [(rows: Int, columns: Int)] = [(3, 4), (5, 2), (4, 4), (4, 5)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure buttons for options and them to stack view
        var previousButton : UIButton?
        
        for (index, option) in options.enumerated() {
            let button = UIButton(type: .custom)
            button.tag = index
            button.setTitle("\(option.rows) x \(option.columns)", for: .normal)
            button.backgroundColor = UIColor.green
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            button.layer.cornerRadius = 16
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.gray.cgColor
            button.addTarget(self, action: #selector(optionButtonTapped), for: .touchUpInside)
            optionsStackView.addArrangedSubview(button)
            
            if let otherButton = previousButton {
                button.heightAnchor.constraint(equalTo: otherButton.heightAnchor, multiplier: 1.0).isActive = true
            }
            previousButton = button
        }
        
        // Configure stack view
        optionsStackView.spacing = 24
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navController = self.navigationController {
            navController.setNavigationBarHidden(true, animated: animated)
        }
    }
    
    @IBAction func optionButtonTapped(sender: UIButton!) {
        performSegue(withIdentifier: "lobbyToGameplay", sender: sender)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lobbyToGameplay" {
            let vc: GameplayViewController = segue.destination as! GameplayViewController
            let selectedOption = options[(sender as! UIButton).tag]
            vc.gameplayViewModel = GameplayViewModel(selectedOption.rows, selectedOption.columns)
        }
    }
}
