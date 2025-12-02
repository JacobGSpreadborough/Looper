//
//  ContentView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 10/24/25.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    // start looper with static demo audio
    @State var looper = Looper(song: Song.demoSong)
    var body: some View {
        TabView{
            Tab("Looper", systemImage: "repeat") {
                LooperView(looper: $looper)
                    .padding()
            }
            Tab("Library", systemImage: "books.vertical.fill"){
                LibraryView(looper: $looper)
                    .padding()
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView(looper: $looper)
                    .padding()
            }
        }
    }
}
