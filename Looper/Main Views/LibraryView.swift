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
    
    var body: some View {
        // TODO: fix ugly background in light mode
        NavigationStack{
            List{
                NavigationLink(destination: AllSongs(looper: $looper), label: {
                    Label("All", systemImage: "line.horizontal.3")
                })
                NavigationLink(destination: Playlists(looper: $looper), label: {
                    Label("Playlists", systemImage: "music.note.list")
                })
                NavigationLink(destination: Favorites(), label: {
                    Label("Favorites", systemImage: "star")
                })
                NavigationLink(destination: Recents(), label: {
                    Label("Recents", systemImage: "clock")
                })
            }
            .navigationTitle("Library")
        }
    }
}

struct Recents: View {
    var body: some View {
        List{
            
        }
        .navigationTitle("Recents")
    }

}
struct Favorites: View {
    var body: some View {
        List{
        }
        .navigationTitle("Playlists")
    }
}
