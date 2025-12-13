//
//  SpeedAndPitch.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/30/25.
//

import SwiftUI

struct SpeedAndPitch: View{
    @ObservedObject var looper: Looper
    @State private var speed: Float = 1
    
    var body: some View {

        VStack {
            Text("Speed: \((speed * 100), specifier: "%0.0f")%")
                .monospacedDigit()
                .fixedSize()
                .padding()
            // TODO make this logarithmic
            Slider(
                value: $speed,
                in: 0.25...1.75,
                label: {}
            )
            .onChange(of: speed, {
                looper.changeSpeed(percent: speed)
            })
            
            //.padding()
            // TODO this doesn't update until the user moves the slider
            Stepper(label: {
                Text("Transpose: \(looper.pitch,specifier: "%0.0f") step\(stringPlural(number: looper.pitch))")
                    .monospacedDigit()
            },
                    onIncrement: {
                looper.changePitch(steps: 1)
            },
                    onDecrement: {
                looper.changePitch(steps: -1)
            })
            //.padding()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

}
