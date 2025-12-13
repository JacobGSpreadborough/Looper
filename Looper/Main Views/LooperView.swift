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
    @ObservedObject var looper: Looper
    @ObservedObject var recorder: Recorder
    
    @State var musicPickerShowing: Bool = false
    @State var documentPickerShowing: Bool = false
    @State var videoPickerShowing: Bool = false
    @State var recorderShowing: Bool = false
    @State private var currentTime: TimeInterval = 0
    @State private var sliderUpdating: Bool = true;
    
    @State private var menuShowing: Bool = true
    
    var body: some View {
        NavigationView {
            // main stack
            VStack {
                // song navigation
                SongNavigator(looper: looper, currentTime: $currentTime, sliderUpdating: $sliderUpdating)
                // speed and pitch
                // TODO add pitch shift by cents
                SpeedAndPitch(looper: looper)
                // loop controls
                LoopNavigator(looper: looper, sliderUpdating: $sliderUpdating, currentTime: $currentTime)
                // volume
                VolumeSlider(looper: looper)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("Add Song", systemImage: "plus") {
                        menuShowing = true
                    }
                })
            }
            .confirmationDialog("Add Song", isPresented: $menuShowing) {
                Button("Apple Library", systemImage: "music.note.list", action: {
                    musicPickerShowing = true
                })
                Button("Documents",systemImage: "folder", action: {
                    documentPickerShowing = true
                    
                })
                // TODO implement
                Button("Videos", systemImage: "camera", action: {
                    videoPickerShowing = true
                })
                // TODO implement
                Button("Record",systemImage: "waveform") {
                    recorderShowing = true
                }
            }
            .sheet(isPresented: $documentPickerShowing, content: {
                DocumentPicker()
            })
            .sheet(isPresented: $musicPickerShowing, content: {
                MusicPicker()
            })
            .sheet(isPresented: $videoPickerShowing, content: {
                VideoPicker()
            })
            .sheet(isPresented: $recorderShowing, content: {
                RecorderView(recorder: recorder)
            })
        }
    }
}
