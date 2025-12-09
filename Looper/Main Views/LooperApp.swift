//
//  LooperApp.swift
//  Looper
//
//  Created by Jacob Spreadborough on 10/24/25.
//

import SwiftUI
import SwiftData

@main
struct LooperApp: App {
    // start looper with static demo audio
    @State var looper = Looper(song: Song.demoSong)
    var body: some Scene {
        WindowGroup {
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
        .modelContainer(for: [Song.self, Playlist.self])
    }
}
