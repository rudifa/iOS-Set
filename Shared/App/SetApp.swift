//
//  SetApp.swift
//  Shared
//
//  Created by Rudolf Farkas on 15.11.21.
//

import SwiftUI

#if os(macOS)
    let windowSize = CGSize(width: 450, height: 800)
#endif

@main
struct SetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            #if os(macOS)
                .frame(minWidth: windowSize.width,
                       maxWidth: windowSize.width,
                       minHeight: windowSize.height,
                       maxHeight: windowSize.height)
            #endif
        }
    }
}
