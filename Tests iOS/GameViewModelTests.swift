//
//  GameViewModelTests.swift
//  SetTests
//
//  Created by Rudolf Farkas on 22.09.21.
//

@testable import Set
import XCTest

class GameViewModelTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func test_SetViewModel() {
        let viewModel = GameViewModel()

        XCTAssertEqual(viewModel.game.cards.count, 12) // initial deal()

        let card0 = viewModel.game.cards[0]
        XCTAssertFalse(viewModel.game.cards[0].isSelected)

        viewModel.touched(card0)
        XCTAssertTrue(viewModel.game.cards[0].isSelected)

        viewModel.touched(card0)
        XCTAssertFalse(viewModel.game.cards[0].isSelected)
    }

    func test_selectedCardsFormASet() {
        //        For example, these three cards form a set:
        //
        //        One red striped diamond
        //        Two red solid diamonds
        //        Three red open diamonds

        let viewModel = GameViewModel()
        viewModel.deal(numberOfCards: 81) // all

        let featureArray = [
            CardPack.Card.Features(.one, .red, .striped, .diamond),
            CardPack.Card.Features(.two, .red, .solid, .diamond),
            CardPack.Card.Features(.three, .red, .open, .diamond),
        ]

        for features in featureArray {
            if let index = viewModel.findCardIndex(by: features) {
                let card = viewModel.game.cards[index]
                print("\(card)")
                viewModel.touched(card)
            }
        }

        XCTAssertTrue(viewModel.game.hasAMatch)
    }

    func test_SetViewModelScores() {
        let viewModel = GameViewModel()
        XCTAssertEqual(viewModel.game.score, 0)

        viewModel.deal(numberOfCards: 3)
        XCTAssertEqual(viewModel.game.score, -10)

        viewModel.cheat()
        XCTAssertEqual(viewModel.game.score, -40)

        viewModel.newGame()
        XCTAssertEqual(viewModel.game.score, 0)
    }
}

