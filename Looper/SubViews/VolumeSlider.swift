//
//  VolumeSlider.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/30/25.
//

import SwiftUI
import AudioKit
import MediaPlayer

struct VolumeSlider: View {
    @ObservedObject var looper: Looper
    @State private var sliderVolume: Float = 2
    @State private var balance: AUValue = 0
    
    private let volumeIcons = ["speaker.3", "speaker.2", "speaker.1", "speaker", "speaker.slash"]
    
    var body: some View {
        
        MPVolumeViewRepresentable()
            .frame(width: 325, height: 20)
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// Source - https://stackoverflow.com/a
// Posted by Jack Vanderpump
// Retrieved 2026-01-17, License - CC BY-SA 4.0

struct MPVolumeViewRepresentable: UIViewRepresentable {

    func makeUIView(context: Context) -> MPVolumeView {
        MPVolumeView(frame: .zero)
    }

    func updateUIView(_ view: MPVolumeView, context: Context) {

        }

}
