//
//  AllSongs.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/9/25.
//

import SwiftUI
import SwiftData

struct AllSongs: View {
    
    @State private var documentPickerShowing: Bool = false
    @State private var musicPickerShowing: Bool = false
    @State private var videoPickerShowing: Bool = false
    @State var menuShowing: Bool = false
    
    @Binding var looper: Looper
    @Binding var currentTab: Int
    
    @State var selection: Set<Song> = []
    
    @Query var savedSongs: [Song]
    @Environment(\.modelContext) var context
    
    var body: some View {
        
        NavigationStack {
            SongList(selection: $selection, editMode: .inactive, deletable: true)
        }
        .onChange(of: selection) {
            // go back to looper tab
            currentTab = 0
            // just use first element of the set, it's impossible to have more than one since the list is not in edit mode
            looper.loadAudio(song: selection.first!)
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
    }
}
