//
//  GameplayViewController.swift
//  Memory Game
//
//  Created by JL on 3/19/19.
//  Copyright © 2019 JL. All rights reserved.
//

import UIKit

class GameplayViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GameplayViewModelDelegate {
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    var gameplayViewModel: GameplayViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
        cardsCollectionView.contentInsetAdjustmentBehavior = .always
        
        if let gameplayViewModel = gameplayViewModel {
            gameplayViewModel.delegate = self
        }
    }
    
    @IBAction func confirmGameOver(_ sender: Any) {
        let alert = UIAlertController(title: "Ending game", message: "Are you sure you want to end the game?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive, handler: { alert in
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        })
        let cancelAction = UIAlertAction(title: "Keep playing!", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout, let gameplayViewModel = gameplayViewModel else {
            return CGSize()
        }
        
        // Calculate card width
        let leftAndRightInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
        let columnSpacing = flowLayout.minimumInteritemSpacing * CGFloat(gameplayViewModel.columns - 1)
        let widthAvailable = collectionView.bounds.size.width - leftAndRightInsets - columnSpacing
        let cardWidth = (widthAvailable / CGFloat(gameplayViewModel.columns)).rounded(.down)
        
        // Calculate card height
        let topAndBottomInsets = flowLayout.sectionInset.top + flowLayout.sectionInset.bottom + collectionView.safeAreaInsets.top + collectionView.safeAreaInsets.bottom
        let rowSpacing = flowLayout.minimumLineSpacing * CGFloat(gameplayViewModel.rows - 1)
        let heightAvailable = collectionView.bounds.size.height - topAndBottomInsets - rowSpacing
        let cardHeight = (heightAvailable / CGFloat(gameplayViewModel.rows)).rounded(.down)
        
        return CGSize(width: cardWidth, height: cardHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let gameplayViewModel = gameplayViewModel else {
            return 0
        }
        
        return gameplayViewModel.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        
        guard let gameplayViewModel = gameplayViewModel else {
            return cell
        }
        
        let card = gameplayViewModel.cards[indexPath.row]
        cell.cardImageViewFront.image = UIImage(named: card.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell

        if let gameplayViewModel = gameplayViewModel {
            let card = gameplayViewModel.cards[indexPath.row]
            if !card.isFlipped {
                cell.flipCardImageView(reverse: card.isFlipped)
                gameplayViewModel.flipCard(atIndex: indexPath.row)
            }
        }
    }
    
    func gameViewModel(_ gameViewModel: GameplayViewModel, didFinishGameWith timeToVictory: Double) {
        let alert = UIAlertController(title: "Congrats!", message: "You matched all the cards! It took you \(Int(timeToVictory)) seconds to solve.", preferredStyle: .alert)
        
        let goToLobbyAction = UIAlertAction(title: "Go to lobby", style: .default, handler: { alert in
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        })
        
        alert.addAction(goToLobbyAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func gameViewModel(_ gameViewModel: GameplayViewModel, didNotMatchCardAt index: Int, withCardAt otherIndex: Int) {
        cardsCollectionView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.flipImageForCardAt(index: index)
            self.flipImageForCardAt(index: otherIndex)
            self.cardsCollectionView.isUserInteractionEnabled = true
        })
    }
    
    func flipImageForCardAt(index: Int) {
        let cellIndexPath = IndexPath(row: index, section: 0)
        let cell = self.cardsCollectionView.cellForItem(at: cellIndexPath) as! CardCollectionViewCell
        cell.flipCardImageView(reverse: true)
    }
}
