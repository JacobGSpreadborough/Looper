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
    
    @State private var documentPickerShowing: Bool = false
    @State private var musicPickerShowing: Bool = false
    @State private var videoPickerShowing: Bool = false
    @State var menuShowing: Bool = false
    
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
            .navigationTitle("All Songs")
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
