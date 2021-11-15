//
//  GameStateTests.swift
//  SetTests
//
//  Created by Rudolf Farkas on 27.09.21.
//

import SwiftUI
import XCTest

class GameStateTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func test_GameState() {
        var game = GameState(pack: CardPack())

        XCTAssertEqual(game.cards.count, 0)
        XCTAssertEqual(game.deck.count, 0)

        game.new()
        XCTAssertEqual(game.cards.count, 12)
        XCTAssertEqual(game.deck.count, 69)
    }

    func test_selectedCardsFormASet() {
        //        For example, these three cards form a set:
        //
        //        One red striped diamond
        //        Two red solid diamonds
        //        Three red open diamonds

        var game = GameState(pack: CardPack())
        game.new()
        game.deal(numberOfCards: 81) // all

        XCTAssertEqual(game.cards.count, 81)
        XCTAssertEqual(game.deck.count, 0)

        do {
            XCTAssertFalse(game.hasAMatch)
            XCTAssertFalse(game.hasAMismatch)
        }

        var featureArray = [
            CardPack.Card.Features(.one, .red, .striped, .diamond),
            CardPack.Card.Features(.two, .red, .solid, .diamond),
            CardPack.Card.Features(.three, .red, .open, .diamond),
        ]

        do {
            let indices = game.findCardIndices(for: featureArray)
            game.selectCards(at: indices)

            XCTAssert(game.hasAMatch)
            XCTAssertFalse(game.hasAMismatch)
        }
        do {
            game.deselectAll()
            featureArray[0] = CardPack.Card.Features(.one, .red, .striped, .squiggle)
            let indices = game.findCardIndices(for: featureArray)
            game.selectCards(at: indices)

            XCTAssertFalse(game.hasAMatch)
            XCTAssert(game.hasAMismatch)
        }
    }

    func test_GameState2() {
        var game = GameState(pack: CardPack())

        XCTAssertEqual(game.cards.count, 0)
        XCTAssertEqual(game.deck.count, 0)

        game.new(numberOfCards: 3)
        XCTAssertEqual(game.cards.count, 3)
        XCTAssertEqual(game.deck.count, 78)

        for numberOfCards in [3, 6, 9, 12, 15, 18] {
            let repCount = 10000
            var matchCount = 0
            for _ in 0 ..< repCount {
                game.new(numberOfCards: numberOfCards)
                let cards = game.findFirstMatch()
                if cards != nil {
                    matchCount += 1
                }
            }
            print("numberOfCards= \(numberOfCards), matchCount= \(matchCount) / \(repCount)")
        }
    }
}

extension GameState {
    func findCardIndex(by features: CardPack.Card.Features) -> Int? {
        return cards.firstIndex(where: { $0.features == features })
    }

    func findCardIndices(for featureArray: [CardPack.Card.Features]) -> [Int] {
        var indices: [Int] = []
        for features in featureArray {
            if let index = findCardIndex(by: features) {
                indices.append(index)
            }
        }
        return indices
    }
}
