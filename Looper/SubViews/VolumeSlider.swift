//
//  VolumeSlider.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/30/25.
//

import SwiftUI
import AudioKit

struct VolumeSlider: View {
    @ObservedObject var looper: Looper
    @State private var sliderVolume: Float = 2
    @State private var balance: AUValue = 0
    
    private let volumeIcons = ["speaker.3", "speaker.2", "speaker.1", "speaker", "speaker.slash"]
    
    var body: some View {
            // volume slider and icon
            HStack {
                Image(systemName: volumeIcons[Int(4 - sliderVolume)])
                    .fixedSize(horizontal: false, vertical: true)
                Slider(
                    value: $sliderVolume,
                    in: 0...4
                )
                .fixedSize(horizontal: false, vertical: true)
                .onChange(of: sliderVolume, {
                    looper.player.volume = sliderVolume/4
                })
            }

        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
