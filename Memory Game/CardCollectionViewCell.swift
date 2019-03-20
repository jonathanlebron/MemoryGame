//
//  CardCollectionViewCell.swift
//  Memory Game
//
//  Created by JL on 3/19/19.
//  Copyright © 2019 JL. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cardImageViewFront: UIImageView!
    @IBOutlet weak var cardImageViewBack: UIImageView!
    
    
    func flipCardImageView(reverse: Bool) {
        isUserInteractionEnabled = reverse
        if reverse {
            UIView.transition(from: cardImageViewFront,
                              to: cardImageViewBack,
                              duration: 0.3,
                              options: [.transitionFlipFromRight, .showHideTransitionViews],
                              completion: nil)
        } else {
            UIView.transition(from: cardImageViewBack,
                              to: cardImageViewFront,
                              duration: 0.3,
                              options: [.transitionFlipFromLeft, .showHideTransitionViews],
                              completion: nil)
        }
    }
}
