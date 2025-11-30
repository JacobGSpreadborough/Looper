//
//  EQSlider.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/19/25.
//

import SwiftUI
import AudioKit

struct EQSlider: View {
    @Binding var EQ: AUValue
    var label: String
    var range: ClosedRange<AUValue>
    var body: some View {
        VStack{
            Text("\(EQ, specifier: "%0.1f")dB")
                .fixedSize()
                .monospacedDigit()
                .frame(height:150,alignment:.top)
            Slider(
                value: $EQ,
                in: range
            )
            .frame(width:300)
            .fixedSize()
            .rotationEffect(Angle(degrees: -90))
            Text(label)
                .frame(height:150,alignment:.bottom)
        }
        .frame(width: 52)
    }
}
