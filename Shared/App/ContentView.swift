//
//  ContentView.swift
//  Shared
//
//  Created by Rudolf Farkas on 15.11.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = GameViewModel()
    var body: some View {
        Group {
            GameView(viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let svModel = GameViewModel()
        ContentView(viewModel: svModel)
    }
}
