//
//  LibraryView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/1/25.
//

import SwiftUI
import SwiftData
import AVFAudio

struct LibraryView: View {
    
    @Binding var looper: Looper
    @Binding var currentTab: Int
    
    var body: some View {
        // TODO: fix ugly background in light mode
        NavigationStack{
            List{
                NavigationLink(destination: AllSongs(looper: $looper, currentTab: $currentTab), label: {
                    Label("All", systemImage: "line.horizontal.3")
                })
                NavigationLink(destination: Playlists(looper: $looper, currentTab: $currentTab), label: {
                    Label("Playlists", systemImage: "music.note.list")
                })
                NavigationLink(destination: Favorites(currentTab: $currentTab), label: {
                    Label("Favorites", systemImage: "star")
                })
                NavigationLink(destination: Recents(currentTab: $currentTab), label: {
                    Label("Recents", systemImage: "clock")
                })
            }
            .navigationTitle("Library")
        }
    }
}

struct Recents: View {
    @Binding var currentTab: Int
    var body: some View {
        List{
            
        }
        .navigationTitle("Recents")
    }

}
struct Favorites: View {
    @Binding var currentTab: Int
    var body: some View {
        List{
        }
        .navigationTitle("Playlists")
    }
}
