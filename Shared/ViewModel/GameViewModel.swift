//
//  GameViewModel.swift
//  Set
//
//  Created by Rudolf Farkas on 11.09.21.
//

import SwiftUI

class GameViewModel: ObservableObject {
    typealias Card = CardPack.Card

    @Published private(set) var game = GameState(pack: CardPack())

    let timer = SimpleTimer(interval: 1.0)

    init() {
        timer.start {
            self.game.tick(increment: self.timer.interval)
        }
        newGame()
    }

    func newGame() {
        game.new()
    }

    func deal(numberOfCards: Int = 3) {
        game.deal(numberOfCards: numberOfCards)
    }

    func touched(_ card: Card) {
        game.touched(card)
    }

    func cheat() {
        game.cheat()
    }
}

extension CardPack.Card {
    var number: Int {
        switch features.number {
        case .one: return 1
        case .two: return 2
        case .three: return 3
        }
    }

    var color: Color {
        switch features.color {
        case .red: return .red
        case .green: return .green
        case .purple: return .purple
        }
    }

    var shading: Eshading {
        return features.shading
    }

    var symbol: Esymbol {
        return features.symbol
    }
}
