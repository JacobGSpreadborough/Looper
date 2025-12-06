//
//  HelpView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/11/25.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        Text("Help")
            .font(.title)
        VStack {
            Text("\(Image(systemName: "repeat"))/\(Image(systemName: "repeat.badge.xmark")): toggle looping")
                .padding()
            Text("\(Image(systemName: "arrow.uturn.right")): set loop start")
                .padding()
            HStack{
                Text("\(Image(systemName: "arrow.uturn.right"))").rotationEffect(Angle(degrees: 180))
                Text(": set loop end")
            }
            .padding()
            Text("\(Image(systemName: "backward.end")), \(Image(systemName: "forward.end")): move loop start or end forward or backward by 1 second")
                .multilineTextAlignment(.center)
                .frame(width:200)
                .padding()
        }
    }
}
