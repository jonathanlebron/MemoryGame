//
//  GameplayViewModel.swift
//  Memory Game
//
//  Created by JL on 3/19/19.
//  Copyright © 2019 JL. All rights reserved.
//

import Foundation

struct Card {
    var name = ""
    private(set) var isFlipped = false
    
    init(name: String) {
        self.name = name
    }
    
    mutating fileprivate func flip() {
        isFlipped = !isFlipped
    }
}

protocol GameplayViewModelDelegate : class {
    func gameViewModel(_ gameViewModel: GameplayViewModel, didNotMatchCardAt index: Int, withCardAt otherIndex: Int)
    func gameViewModel(_ gameViewModel: GameplayViewModel, didFinishGameWith timeToVictory: Double)
}

class GameplayViewModel {
    private var cardNames: [String] = ["memoryBatCardFront",
                                       "memoryCatCardFront",
                                       "memoryCowCardFront",
                                       "memoryDragonCardFront",
                                       "memoryGarbageManCardFront",
                                       "memoryGhostDogCardFront",
                                       "memoryHenCardFront",
                                       "memoryHorseCardFront",
                                       "memoryPigCardFront",
                                       "memorySpiderCardFront"]
    private var flippedCardIndex: Int
    private var startTime: DispatchTime
    private(set) var cards: [Card]
    let columns: Int
    let rows: Int
    var cardsToMatch: Int
    weak var delegate: GameplayViewModelDelegate?
    
    
    init(_ rows: Int, _ columns: Int) {
        self.cards = []
        self.cardsToMatch = (rows * columns) / 2
        self.flippedCardIndex = -1
        self.columns = columns
        self.rows = rows
        self.startTime = DispatchTime.now()
        
        
        for i in 0..<cardsToMatch {
            let cardName = cardNames[i % cardNames.count]
            let card = Card(name: cardName)
            let matchingCard = Card(name: cardName)
            cards.append(card)
            cards.append(matchingCard)
        }
        
        cards.shuffle()
    }
    
    func flipCard(atIndex: Int) {
        cards[atIndex].flip()
        
        if flippedCardIndex != -1 {
            if cards[atIndex].name != cards[flippedCardIndex].name {
                cards[atIndex].flip()
                cards[flippedCardIndex].flip()
                
                if let delegate = delegate {
                    delegate.gameViewModel(self, didNotMatchCardAt: atIndex, withCardAt: flippedCardIndex)
                }
            } else {
                cardsToMatch -= 1
                if cardsToMatch == 0 {
                    let timeElapsed = DispatchTime.now().uptimeNanoseconds -  self.startTime.uptimeNanoseconds
                    let timeElapsedInSeconds = Double(timeElapsed) / 1_000_000_000
                    if let delegate = delegate {
                        delegate.gameViewModel(self, didFinishGameWith: timeElapsedInSeconds)
                    }
                }
            }
            
            flippedCardIndex = -1
        } else {
            flippedCardIndex = atIndex
        }
    }
    
    func reset() {
        self.cardsToMatch = (rows * columns) / 2
        self.flippedCardIndex = -1
        self.startTime = DispatchTime.now()
        
        for i in 0..<cards.count {
            cards[i].flip()
        }
        
        cards.shuffle()
    }
}
