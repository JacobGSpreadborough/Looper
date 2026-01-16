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
    
    @ObservedObject var looper: Looper
    @ObservedObject var recorder: Recorder
    @Binding var currentTab: Int
    
    @State private var documentPickerShowing: Bool = false
    @State private var musicPickerShowing: Bool = false
    @State private var videoPickerShowing: Bool = false
    @State private var recorderShowing: Bool = false
    @State var menuShowing: Bool = false
    
    var body: some View {
        // TODO: fix ugly background in light mode
        NavigationStack{
            List{
                NavigationLink(destination: AllSongs(looper: looper, recorder: recorder, currentTab: $currentTab), label: {
                    Label("All", systemImage: "line.horizontal.3")
                })
                NavigationLink(destination: Playlists(looper: looper, currentTab: $currentTab), label: {
                    Label("Playlists", systemImage: "music.note.list")
                })
                NavigationLink(destination: Favorites(currentTab: $currentTab), label: {
                    Label("Favorites", systemImage: "star")
                })
                NavigationLink(destination: Recents(looper: looper, currentTab: $currentTab), label: {
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
            // TODO: systemImages don't work, and this looks bad in iOS 26
            // recreate the old confirmationDialog appearance
            .confirmationDialog("Add Song", isPresented: $menuShowing) {
                Button("Apple Library", systemImage: "music.note.list", action: {
                    musicPickerShowing = true
                })
                Button("Documents",systemImage: "folder", action: {
                    documentPickerShowing = true
                    
                })
                // TODO implement
                /*
                Button("Videos", systemImage: "camera", action: {
                    videoPickerShowing = true
                })
                */
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
            .navigationTitle("Library")
        }
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
