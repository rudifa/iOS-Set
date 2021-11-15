//
//  SetModel.swift
//  Set
//
//  Created by Rudolf Farkas on 11.09.21.
//

import Foundation

struct CardPack {
    private(set) var cards: [Card]

    init() {
        cards = []
        var index = 0
        for number in Card.Enumber.allCases {
            for color in Card.Ecolor.allCases {
                for shading in Card.Eshading.allCases {
                    for symbol in Card.Esymbol.allCases {
                        cards.append(Card(id: index, features: Card.Features(number, color, shading, symbol)))
                        index += 1
                    }
                }
            }
        }
    }

    struct Card: Identifiable, Equatable, CustomStringConvertible {
        let id: Int
        let features: Features
        var isSelected = false

        var description: String {
            "id: \(id) \(features.number) \(features.color) \(features.shading) \(features.symbol) isSelected: \(isSelected)"
        }

        struct Features: Equatable {
            let number: Enumber
            let color: Ecolor
            let shading: Eshading
            let symbol: Esymbol

            init(_ number: Enumber, _ color: Ecolor, _ shading: Eshading, _ symbol: Esymbol) {
                self.number = number
                self.color = color
                self.shading = shading
                self.symbol = symbol
            }
        }

        enum Enumber: Int, CaseIterable {
            case one, two, three
        }

        enum Ecolor: Int, CaseIterable {
            case red, green, purple
        }

        enum Eshading: Int, CaseIterable {
            case solid, striped, open
        }

        enum Esymbol: Int, CaseIterable {
            case diamond, squiggle, oval
        }

//        static func allSame<F>(f0: F, f1: F, f2: F) -> Bool where F: Equatable {
//            return f0 == f1 && f1 == f2
//        }
//
//        static func allDifferent<F>(f0: F, f1: F, f2: F) -> Bool where F: Equatable {
//            return f0 != f1 && f0 != f2 && f1 != f2
//        }
//
//        static func matched<F>(_ f0: F, _ f1: F, _ f2: F) -> Bool where F: Equatable {
//            return (f0 == f1 && f1 == f2) || (f0 != f1 && f0 != f2 && f1 != f2)
//        }
    }

    struct Triplet {
        var c0: Card
        var c1: Card
        var c2: Card

        static func matched<F>(_ f0: F, _ f1: F, _ f2: F) -> Bool where F: Equatable {
            return (f0 == f1 && f1 == f2) || (f0 != f1 && f0 != f2 && f1 != f2)
        }

        var isASet: Bool {
            Self.matched(c0.features.color, c1.features.color, c2.features.color) &&
                Self.matched(c0.features.number, c1.features.number, c2.features.number) &&
                Self.matched(c0.features.shading, c1.features.shading, c2.features.shading) &&
                Self.matched(c0.features.symbol, c1.features.symbol, c2.features.symbol)
        }
    }
}

extension CardPack.Triplet {
    init?(cards: [CardPack.Card]) {
        if cards.count == 3 {
            self = CardPack.Triplet(c0: cards[0], c1: cards[1], c2: cards[2])
        } else {
            return nil
        }
    }
}

extension Bool {
    mutating func set() {
        self = true
    }

    mutating func reset() {
        self = false
    }
}
