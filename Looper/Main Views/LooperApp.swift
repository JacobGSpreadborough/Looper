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
    // start looper with the most recently played song
    // defaults to demo audio
    @StateObject var looper = Looper(song: Playlist.recents.songs.first!)
    @StateObject var recorder = Recorder()
    @State var currentTab = 1
    var body: some Scene {
        WindowGroup {
            TabView (selection: $currentTab){
                LooperView(looper: looper, recorder: recorder)
                    .tabItem{
                        Image(systemName: "repeat")
                        Text("Looper")
                    }
                    .tag(0)
                    .padding()
                LibraryView(looper: looper, recorder: recorder, currentTab: $currentTab)
                    .tabItem {
                        Image(systemName: "books.vertical.fill")
                        Text("Library")
                    }
                    .tag(1)
                    .padding()
                SettingsView(looper: looper)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(2)
                    .padding()
            }
        }
        .modelContainer(for: [Song.self, Playlist.self])
    }
}
