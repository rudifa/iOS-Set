//
//  SetGameTests.swift
//  SetTests
//
//  Created by Rudolf Farkas on 11.09.21.
//

@testable import Set
import XCTest

class CardPackTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func test_CardPack() {
        let pack = CardPack()
        do {
            XCTAssertEqual(pack.cards.count, 81)
            XCTAssertEqual(pack.cards[80].id, 80)
            XCTAssertEqual(pack.cards[0].features, CardPack.Card.Features(.one, .red, .solid, .diamond))
            XCTAssertEqual(pack.cards[1].features, CardPack.Card.Features(.one, .red, .solid, .squiggle))
            XCTAssertEqual(pack.cards[3].features, CardPack.Card.Features(.one, .red, .striped, .diamond))
            XCTAssertEqual(pack.cards[9].features, CardPack.Card.Features(.one, .green, .solid, .diamond))
            XCTAssertEqual(pack.cards[27].features, CardPack.Card.Features(.two, .red, .solid, .diamond))
        }
        do {
            XCTAssertFalse(pack.cards[0].isSelected)
            XCTAssertFalse(pack.cards[80].isSelected)
        }
        do {
            var cards = pack.cards

            XCTAssertFalse(cards[0].isSelected)

            cards[0].isSelected.toggle()
            XCTAssertTrue(cards[0].isSelected)

            cards[0].isSelected.toggle()
            XCTAssertFalse(cards[0].isSelected)

            cards[0].isSelected.set()
            XCTAssertTrue(cards[0].isSelected)

            cards[0].isSelected.reset()
            XCTAssertFalse(cards[0].isSelected)

        }
        do {
            XCTAssertEqual("\(pack.cards[0])", "id: 0 one red solid diamond isSelected: false")
            XCTAssertEqual("\(pack.cards[9])", "id: 9 one green solid diamond isSelected: false")
        }
    }

    func test_Triplet() {
        typealias Card = CardPack.Card
        typealias Triplet = CardPack.Triplet

//        For example, these three cards form a set:
//
//        One red striped diamond
//        Two red solid diamonds
//        Three red open diamonds

        let card0 = Card(id: 0, features: Card.Features(.one, .red, .striped, .diamond))
        let card1 = Card(id: 1, features: Card.Features(.two, .red, .solid, .diamond))
        let card2 = Card(id: 2, features: Card.Features(.three, .red, .open, .diamond))
        let card21 = Card(id: 2, features: Card.Features(.three, .green, .open, .diamond))

        // init with 3 cards

        do {
            let triplet = Triplet(c0: card0, c1: card1, c2: card2)
            XCTAssertTrue(triplet.isASet)
        }
        do {
            let triplet = Triplet(c0: card0, c1: card1, c2: card21)
            XCTAssertFalse(triplet.isASet)
        }

        // init with [cards]

        do {
            let triplet = Triplet(cards: [card0, card1, card2])
            XCTAssertNotNil(triplet)
            XCTAssertTrue(triplet!.isASet)
        }
        do {
            let triplet = Triplet(cards: [card0, card1, card21])
            XCTAssertNotNil(triplet)
            XCTAssertFalse(triplet!.isASet)
        }
        do {
            let triplet = Triplet(cards: [card0, card1])
            XCTAssertNil(triplet)
        }
    }
}
