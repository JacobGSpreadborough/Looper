//
//  ContentView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 10/24/25.
//

import SwiftUI
import SoundpipeAudioKit
import AudioKit
import Waveform

let fileName:String = "Dire Straits - Romeo and Juliet"

struct ContentView: View {
    @State var looper = Looper(url: Bundle.main.url(forResource: fileName, withExtension: "mp3")!)
    @State var musicPickerShowing: Bool = false
    @State var documentPickerShowing: Bool = false
    @State var videoPickerShowing: Bool = false
    @State private var currentTime: TimeInterval = 0
    @State private var sliderUpdating: Bool = true;
    
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
            .toolbarRole(.navigationStack)
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    NavigationLink(destination: HelpView(), label: {
                        Image(systemName: "info.circle")
                    })
                })
                ToolbarItem(placement: .subtitle, content: {
                    ImportAudioMenu(musicPickerShowing: $musicPickerShowing, documentPickerShowing: $documentPickerShowing, videoPickerShowing: $videoPickerShowing)
                })
                ToolbarItem(placement: .topBarTrailing, content: {
                    NavigationLink(destination: SettingsView(looper: $looper), label: {
                        Image(systemName: "gear")
                    })
                })
            }
            .padding()
        }
        .sheet(isPresented: $documentPickerShowing, content:{DocumentPicker(looper: $looper)})
        .sheet(isPresented: $musicPickerShowing, content: {MusicPicker(looper: $looper)})
        .sheet(isPresented: $videoPickerShowing, content: {VideoPicker()})
    }
}

#Preview {
    ContentView()
}
