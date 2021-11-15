//
//  GameState.swift
//  Set
//
//  Created by Rudolf Farkas on 27.09.21.
//

import Foundation

struct GameState {
    typealias Card = CardPack.Card

    private let pack: CardPack
    private(set) var deck: [Card] = []
    private(set) var cards: [Card] = []
    private(set) var state = State.idle
    private(set) var dealCount = 0
    private(set) var cheatCount = 0
    private(set) var scoreKeeper = ScoreKeeper()
    private(set) var elapsedSecondsThisGame = 0

    init(pack: CardPack) {
        self.pack = pack
    }

    mutating func new(numberOfCards: Int = 12) {
        deck = pack.cards.shuffled()
        cards = []
        state = .running
        dealCount = 0
        cheatCount = 0
        deal(numberOfCards: numberOfCards)
        scoreKeeper = ScoreKeeper()
        elapsedSecondsThisGame = 0
    }

    var score: Int {
        scoreKeeper.score
    }

    var bounty: Int {
        state == .running ? scoreKeeper.bounty : 0
    }

    var elapsedRoundTime: TimeInterval {
        TimeInterval(scoreKeeper.elapsedSecondsThisRound)
    }

    var elapsedGameTime: TimeInterval {
        TimeInterval(elapsedSecondsThisGame)
    }

    var isCheatAllowed: Bool {
        state == .running && cheatCount < 1
    }

    var isDealAllowed: Bool {
        state == .running && (dealCount < 2 || findFirstMatch() == nil)
    }

    var selectedCards: [Card] {
        cards.filter({ $0.isSelected })
    }

    var numberOfSelectedCards: Int {
        selectedCards.count
    }

    var hasAMatch: Bool {
        guard let triplet = CardPack.Triplet(cards: selectedCards) else { return false }
        return triplet.isASet
    }

    var hasAMismatch: Bool {
        guard let triplet = CardPack.Triplet(cards: selectedCards) else { return false }
        return !triplet.isASet
    }

    var matched: Matched {
        guard let triplet = CardPack.Triplet(cards: selectedCards) else { return .neither }
        return triplet.isASet ? .yes : .no
    }

    var isGameOver: Bool {
        state == .over
    }

    mutating func checkGameOver() {
        if deck.count == 0, findFirstMatch() == nil {
            state = .over
        }
    }

    func index(of card: Card) -> Int? {
        cards.firstIndex(where: { $0.id == card.id })
    }

    mutating func deal(numberOfCards: Int = 3) {
        if isDealAllowed {
            dealCount += 1
            for _ in 0 ..< min(numberOfCards, deck.count) {
                cards.append(deck.removeLast())
            }
            scoreKeeper.update(.deal)
        }
    }

    mutating func selectCard(at index: Int) {
        if cards.indices.contains(index) {
            cards[index].isSelected.set()
        }
    }

    mutating func selectCards(at indices: [Int]) {
        for index in indices {
            selectCard(at: index)
        }
    }

    mutating func select(_ card: Card) {
        if let index = index(of: card) {
            cards[index].isSelected.set()
        }
    }

    mutating func deselectAll() {
        for index in cards.indices {
            cards[index].isSelected.reset()
        }
    }

    mutating func replaceAllSelected() {
        for card in cards.filter({ $0.isSelected }) {
            if let index = index(of: card) {
                if let last = deck.popLast() {
                    cards[index] = last
                } else {
                    cards.remove(at: index)
                }
            } else {
                fatalError()
            }
        }
    }

    mutating func deselectAllAndDeal(numberOfCards: Int = 3) {
        deselectAll()
        deal()
    }

    mutating func touched(_ card: Card, cheat: Bool = false) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { fatalError() }
        // print("touched \(index) \(cards[index])")

        switch numberOfSelectedCards {
        case 0 ... 1:
            cards[index].isSelected.toggle()
        case 2:
            cards[index].isSelected.toggle()
            if cards[index].isSelected { // now 3 selected
                if hasAMatch {
                    print("touched \(index) set match")
                    scoreKeeper.update(cheat ? .cheat : .match)
                } else {
                    print("touched \(index) set no match")
                    scoreKeeper.update(.nomatch)
                }
            }
        case 3:
            if hasAMatch {
                replaceAllSelected()
            } else {
                deselectAll()
            }
            select(card) // if still there
            checkGameOver()
        default:
            fatalError()
        }
    }

    func findFirstMatch() -> [Card]? {
        for f in 0 ..< cards.count {
            for s in f + 1 ..< cards.count {
                for t in s + 1 ..< cards.count {
                    if CardPack.Triplet(c0: cards[f], c1: cards[s], c2: cards[t]).isASet {
                        return [cards[f], cards[s], cards[t]]
                    }
                }
            }
        }
        return nil
    }

    mutating func cheat() {
        if isCheatAllowed {
            cheatCount += 1
            deselectAll()
            if let cards = findFirstMatch() {
                cards.forEach({ touched($0, cheat: true) })
            }
        }
    }

    mutating func tick(increment: TimeInterval) {
        if state == .running {
            scoreKeeper.oneSecondTick()
            elapsedSecondsThisGame += 1
        }
    }

    enum Matched {
        case yes
        case no
        case neither
    }

    enum State {
        case idle
        case running
        case over
    }
}

extension GameState {
    enum Event {
        case deal
        case cheat
        case match
        case nomatch
        case reset
    }

    struct ScoreKeeper {
        let maxBounty = 30
        private(set) var score = 0
        private(set) var elapsedSecondsThisRound = 0

        mutating func update(_ event: Event) {
            switch event {
            case .deal:
                score -= maxBounty / 3 // small penalty
            case .cheat:
                score -= maxBounty // large penalty
            case .match:
                score += bounty
                elapsedSecondsThisRound = 0
            case .nomatch:
                score -= maxBounty / 3 // small penalty
            case .reset:
                elapsedSecondsThisRound = 0
            }
        }

        mutating func oneSecondTick() {
            elapsedSecondsThisRound += 1
            // print("bounty#2= \(bounty)")
        }

        var bountyDouble: Double {
            Double(maxBounty) * exp(-Double(elapsedSecondsThisRound) / 180.0)
        }

        var bounty: Int {
            Int(ceil(bountyDouble))
        }
    }
}
