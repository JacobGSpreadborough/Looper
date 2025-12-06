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
        NavigationStack{
            List{
                NavigationLink(destination: AllSongs(looper: $looper), label: {
                    Label("All", systemImage: "line.horizontal.3")
                })
                NavigationLink(destination: Playlists(), label: {
                    Label("Playlists", systemImage: "music.note.list")
                })
                NavigationLink(destination: Favorites(), label: {
                    Label("Favorites", systemImage: "star")
                })
                NavigationLink(destination: Recents(), label: {
                    Label("Recents", systemImage: "clock")
                })
            }
        }
        .navigationTitle("Library")
    }
}


struct AllSongs: View {
    
    @State private var documentPickerShowing: Bool = false
    @State private var musicPickerShowing: Bool = false
    @State private var videoPickerShowing: Bool = false
    
    @Binding var looper: Looper
    
    @State var menuShowing: Bool = false
    @State var selection: Song?
    
    @Query var savedSongs: [Song]
    @Environment(\.modelContext) var context
    
    var body: some View {
        
        NavigationStack {
            SongList(selection: $selection, looper: $looper)
        }
        .onChange(of: selection) {
            looper.loadAudio(song: selection!)
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

struct Playlists: View {
    
    @Query private var playlists: [Playlist]
    @Query private var songs: [Song]
    @State private var selection = Set<Song>()
    @Environment(\.modelContext) private var context
    @State private var newPlaylist: Playlist!
    
    var body: some View {
        // splitview or stack? what's the difference?
        NavigationStack{
            List{
                // TODO just do this in the list
                ForEach(playlists) { playlist in
                    NavigationLink(playlist.name){
                        ForEach(playlist.songs) { song in
                            // search in playlist?
                            Text(song.title)
                        }
                    }
                }
                Button("New Playlist", systemImage: "plus", action: addPlaylist)
            }
            .sheet(item: $newPlaylist){ playlist in
                NavigationStack{
                    List(songs, id: \.self, selection: $selection) { song in
                        Text(song.title)
                    }
                }
            }
            .navigationTitle("Playlists")
        }
    }
    private func addPlaylist() {
        let newPlaylist = Playlist(name: "", songs: [])
        context.insert(newPlaylist)
        self.newPlaylist = newPlaylist
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
