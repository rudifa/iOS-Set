//
//  CardView.swift
//  Set
//
//  Created by Rudolf Farkas on 11.09.21.
//

import SwiftUI
import rfSwiftUI

public extension Color {
    static let paleGold = Color(red: 0.98, green: 0.96, blue: 0.74)
    static let paleGray = Color(red: 0.91, green: 0.91, blue: 0.91)
    static let walnut = Color(red: 0.87, green: 0.66, blue: 0.41)
    static let mahogany6 = Color(red: 0.318, green: 0.082, blue: 0.082)
    static let mahogany7 = Color(red: 0.239, green: 0.063, blue: 0.063)
    static let mahogany8 = Color(red: 0.157, green: 0.039, blue: 0.043)
    static let mahogany9 = Color(red: 0.078, green: 0.02, blue: 0.02)

// https://colorswall.com/palette/27355/
//    Palette Shades of Mahogany color #CA3435 hex has 10 HEX, RGB codes colors:
//    HEX: #ca3435 RGB: (202, 52, 53), HEX: #b62f30 RGB: (182, 47, 48), HEX: #a22a2a RGB: (162, 42, 42), HEX: #8d2425 RGB: (141, 36, 37), HEX: #791f20 RGB: (121, 31, 32), HEX: #651a1b RGB: (101, 26, 27), HEX: #511515 RGB: (81, 21, 21), HEX: #3d1010 RGB: (61, 16, 16), HEX: #280a0b RGB: (40, 10, 11), HEX: #140505 RGB: (20, 5, 5).
//

}

struct CardView: View {
    private var card: GameViewModel.Card
    private var matched: GameState.Matched

    init(_ card: GameViewModel.Card, matched: GameState.Matched) {
        self.card = card
        self.matched = matched
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: Const.cornerRadius)
                    .strokeBorder(.black, lineWidth: borderWidth(matched, card.isSelected), fill: fgColor(matched, card.isSelected))
                CardSymbols(card: card, size: geometry.size)
            }
        }
    }

    private func fgColor(_ cardsMatched: GameState.Matched, _: Bool) -> Color {
        switch (card.isSelected, cardsMatched) {
        case (true, .no):
            return .paleGray
        case (true, _):
            return .paleGold
        default:
            return .white
        }
    }

    private func borderWidth(_ cardsMatched: GameState.Matched, _: Bool) -> CGFloat {
        switch (card.isSelected, cardsMatched) {
        case (true, _):
            return Const.lineWidth * 3
        default:
            return Const.lineWidth
        }
    }

    private enum Const {
        static let cornerRadius: CGFloat = 7
        static let lineWidth: CGFloat = 1
    }
}

struct CardSymbols: View {
    let card: GameViewModel.Card
    let size: CGSize

    var body: some View {
        let shapeSize = CGSize(width: size.width * 0.63, height: size.width * 0.30)
        let lineWidth: CGFloat = 3.0
        VStack {
            ForEach(0 ..< card.number, id: \.self) { _ in
                Group {
                    switch (card.symbol, card.shading) {
                    case (.oval, .solid):
                        Capsule().fill()
                    case (.diamond, .solid):
                        Diamond().fill()
                    case (.squiggle, .solid):
                        Squiggle().fill()

                    case (.oval, .striped):
                        Capsule().striped(lineWidth: lineWidth)
                    case (.diamond, .striped):
                        Diamond().striped(lineWidth: lineWidth)
                    case (.squiggle, .striped):
                        Squiggle().striped(lineWidth: lineWidth)

                    case (.oval, .open):
                        Capsule().stroke(lineWidth: lineWidth)
                    case (.diamond, .open):
                        Diamond().stroke(lineWidth: lineWidth)
                    case (.squiggle, .open):
                        Squiggle().stroke(lineWidth: lineWidth)
                    }
                }
                .frame(width: shapeSize.width, height: shapeSize.height)
            }
        }
        .foregroundColor(card.color)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
         let cardSelected = GameViewModel.Card(id: 0, features: GameViewModel.Card.Features(.one, .green, .striped, .squiggle), isSelected: true)
        let cardNotSelected = GameViewModel.Card(id: 0, features: GameViewModel.Card.Features(.one, .red, .solid, .diamond), isSelected: false)
        let cardNotSelected2 = GameViewModel.Card(id: 0, features: GameViewModel.Card.Features(.three, .red, .open, .oval), isSelected: false)

        ZStack {
            Color.walnut.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    CardView(cardSelected, matched: .neither)
                    CardView(cardSelected, matched: .yes)
                    CardView(cardSelected, matched: .no)
                }
                HStack {
                    CardView(cardNotSelected, matched: .neither)
                    CardView(cardNotSelected, matched: .yes)
                    CardView(cardNotSelected, matched: .no)
                }

                HStack {
                    CardView(cardNotSelected2, matched: .neither)
                    CardView(cardNotSelected2, matched: .yes)
                    CardView(cardNotSelected2, matched: .no)
                }
            }
        }
    }
}
