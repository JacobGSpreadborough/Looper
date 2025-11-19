//
//  CustomStyles.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/19/25.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
      configuration.label
      .foregroundColor(.white)
      .padding()
      .background(Color.blue)
      .clipShape(RoundedRectangle(cornerRadius: 10))
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
