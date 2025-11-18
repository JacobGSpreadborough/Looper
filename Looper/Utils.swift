//
//  Utils.swift
//  Looper
//
//  Created by Jacob Spreadborough on 10/24/25.
//

import Foundation
import SwiftUI
import AudioKit

class Utils {
    public static func timeFormatter(time: Double) -> String {
        let minutes = Int(time/60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        // there must be a cleaner way to do this
        let milliseconds = Int((time - Double(Int(time))) * 100)
        return String(format: "%02d:%02d:%02d", minutes,seconds,milliseconds)
    }
}
// 
func stringPlural(number: Float) -> String {
    if(number != 1 && number != -1) {
        return "s"
    }
    return ""
}

struct CustomButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
      configuration.label
      .foregroundColor(.white)
      .padding()
      .background(Color.blue)
      .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

struct EQSlider: View {
    @Binding var EQ: AUValue
    var label: String
    var min: AUValue
    var max: AUValue
    var body: some View {
        VStack{
            Text("\(EQ, specifier: "%0.1f")dB")
                .fixedSize()
                .monospacedDigit()
                .frame(height:150,alignment:.top)
            Slider(
                value: $EQ,
                in: min...max
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

struct CustomLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .foregroundStyle(.foreground)
            configuration.title
                .foregroundStyle(.foreground)
        }
            .fixedSize()
            .monospacedDigit()
            .frame(height:150,alignment:.top)
    }
}
