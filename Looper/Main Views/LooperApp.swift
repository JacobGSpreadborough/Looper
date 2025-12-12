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
    @State var currentTab = 0
    var body: some Scene {
        WindowGroup {
            TabView (selection: $currentTab){
                LooperView(looper: $looper)
                    .tabItem{
                        Image(systemName: "repeat")
                        Text("Looper")
                    }
                    .tag(0)
                LibraryView(looper: $looper, currentTab: $currentTab)
                    .tabItem {
                        Image(systemName: "books.vertical.fill")
                        Text("Library")
                    }
                    .tag(1)
                SettingsView(looper: $looper)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(2)
                }
            
        }
        .modelContainer(for: [Song.self, Playlist.self])
    }
}
