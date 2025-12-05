//
//  ContentView 2.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/1/25.
//



import SwiftUI
import SoundpipeAudioKit
import AudioKit
import Waveform

struct LooperView: View {
    @Binding var looper: Looper
    @State var musicPickerShowing: Bool = false
    @State var documentPickerShowing: Bool = false
    @State var videoPickerShowing: Bool = false
    @State private var currentTime: TimeInterval = 0
    @State private var sliderUpdating: Bool = true;
    
    @State private var menuShowing: Bool = true
    
    var body: some View {
        NavigationView {
            // main stack
            VStack {
                // song navigation
                SongNavigator(looper: $looper, currentTime: $currentTime, sliderUpdating: $sliderUpdating)
                // speed and pitch
                // TODO add pitch shift by cents
                SpeedAndPitch(looper: $looper)
                // loop controls
                LoopNavigator(looper: $looper, sliderUpdating: $sliderUpdating, currentTime: $currentTime)
                // volume
                VolumeSlider(looper: $looper)
            }
        }
    }
}
