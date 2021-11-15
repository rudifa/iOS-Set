//
//  GameView.swift
//  Set
//
//  Created by Rudolf Farkas on 11.09.21.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    @State var numberOfCards = 12

    var body: some View {
        ZStack {
            // Color.walnut.edgesIgnoringSafeArea(.all)
            Color.mahogany6.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    SameWidth(view: TitledInfo(title: "Score", info: "\(viewModel.game.score)"))
                    SameWidth(view: TitledInfo(title: "Deck", info: "\(viewModel.game.deck.count)"))
                    SameWidth(view: TitledInfo(title: "Time", info: hms(from: viewModel.game.elapsedGameTime)))
                    SameWidth(view: TitledInfo(title: "Bounty", info: "\(viewModel.game.bounty)"))
                }
                .padding(5)

                AspectVGrid(items: viewModel.game.cards, aspectRatio: 2 / 3) { item in
                    CardView(item, matched: viewModel.game.matched)
                        .onTapGesture {
                            // print("tap \(item.id)")
                            viewModel.touched(item)
                        }
                }
                .padding(5)

                VStack {
                    if viewModel.game.isGameOver {
                        Text("GAME OVER")
                            .font(Font.custom("Seven Segment", size: 40))
                            .padding()
                            .foregroundColor(.blue)
                    }
                    Buttons(viewModel: viewModel)
                }
                .padding(5)
                .font(Font.custom("Seven Segment", size: 25))
            }
        }
    }
}

struct Buttons: View {
    var viewModel: GameViewModel
    @State private var isDealEnabled = true
    @State private var isCheatEnabled = true
    var body: some View {
        HStack {
            Spacer()
            Button {
                viewModel.deal()
                isDealEnabled = viewModel.game.isDealAllowed
            } label: {
                Text("Deal")
            }
            .niceButton(foregroundColor: .white.opacity(opacityIfEnabled(isDealEnabled)))

            Spacer()

            Button {
                viewModel.newGame()
                isDealEnabled = viewModel.game.isDealAllowed
                isCheatEnabled = viewModel.game.isCheatAllowed
            } label: {
                Text("New game")
            }
            .niceButton(foregroundColor: .white)

            Spacer()

            Button {
                viewModel.cheat()
                isCheatEnabled = viewModel.game.isCheatAllowed
            } label: {
                Text("Cheat")
            }
            .niceButton(foregroundColor: .white.opacity(opacityIfEnabled(isCheatEnabled)))

            Spacer()
        }
    }

    private func opacityIfEnabled(_ enabled: Bool) -> Double {
        return enabled ? 1.0 : 0.5
    }
}

func hms(from interval: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    // styles are positional, abbreviated, short, full, spellOut and brief
    formatter.unitsStyle = .positional
    return formatter.string(from: TimeInterval(interval))!
}

struct SameWidth<V: View>: View {
    let view: V
    var body: some View {
        HStack {
            Spacer()
            view
            Spacer()
        }
    }
}

struct TitledInfo: View {
    let title: String
    let info: String
    var body: some View {
        VStack {
            Text(title).font(Font.custom("Seven Segment", size: 15))
            Text(info).font(Font.custom("Seven Segment", size: 30))
        }
        .foregroundColor(.white)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let svModel = GameViewModel()
        GameView(viewModel: svModel)
    }
}

