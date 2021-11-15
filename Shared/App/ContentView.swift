//
//  ContentView.swift
//  Shared
//
//  Created by Rudolf Farkas on 15.11.21.
//

import SwiftUI

#if os(macOS)
    let windowSize = CGSize(width: 450, height: 800)
#endif

struct ContentView: View {
    var body: some View {
        Group {
            Text("Hello, world!")
                .padding()
        }
#if os(macOS)
    .frame(minWidth: windowSize.width,
           maxWidth: windowSize.width,
           minHeight: windowSize.height,
           maxHeight: windowSize.height)
#endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
