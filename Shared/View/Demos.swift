//
//  Demos.swift
//  Set
//
//  Created by Rudolf Farkas on 12.09.21.
//

import SwiftUI

struct Demos: View {
    var body: some View {
        VStack {
            //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Content5View()
        }

    }
}

// https://www.hackingwithswift.com/quick-start/swiftui/swiftuis-built-in-shapes

struct Content5View: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray)
                .frame(width: 200, height: 200)

            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.red)
                .frame(width: 200, height: 200)

            Capsule()
                .fill(Color.green)
                .frame(width: 100, height: 50)

            Ellipse()
                .fill(Color.blue)
                .frame(width: 100, height: 50)

            Circle()
                .fill(Color.white)
                .frame(width: 100, height: 50)
        }
    }
}

struct Demos_Previews: PreviewProvider {
    static var previews: some View {
        Demos()
    }
}
