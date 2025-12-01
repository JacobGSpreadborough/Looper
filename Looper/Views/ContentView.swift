//
//  ContentView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 10/24/25.
//

import SwiftUI
import AVFAudio

let demoFileName:String = "demo audio"
let demoURL = Bundle.main.url(forResource: demoFileName, withExtension: "mp3")!
let demoSong = Song(title: "track 0",
                       artist: "demo",
                       file: try!AVAudioFile(forReading: demoURL),
                       url: demoURL,
                       image: nil
                    )

struct ContentView: View {
    @State var looper = Looper(song: demoSong)
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

#Preview {
    ContentView()
}
