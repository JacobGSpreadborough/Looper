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
    @State var musicPickerShowing: Bool = false
    @State var documentPickerShowing: Bool = false
    @State var videoPickerShowing: Bool = false
    
    var body: some View {
        NavigationStack{
            List{
                NavigationLink(destination: AllSongs(looper: $looper), label: {
                    Label("All", systemImage: "line.horizontal.3")
                })
                NavigationLink(destination: Playlists(), label: {
                    Label("Playlists", systemImage: "music.note.square.stack")
                })
                NavigationLink(destination: Favorites(), label: {
                    Label("Favorites", systemImage: "star")
                })
                NavigationLink(destination: Recents(), label: {
                    Label("Recents", systemImage: "clock")
                })
            }
        }
    }
}


struct AllSongs: View {
    
    @Query var savedSongs: [Song]
    @Environment(\.modelContext) var context
    @State private var newSong: Song!
    @State private var newDocument: Song!
    @State private var newVideo: Song!
    
    @Binding var looper: Looper
    
    @State var searchQuery: String = ""
    @State var searchResults: [Song] = []
    
    var isSearching: Bool {
        return !searchQuery.isEmpty
    }
    
    var body: some View {
        List{
            if isSearching {
                ForEach(searchResults) { song in
                    Button(song.artist + " - " + song.title) {
                        looper.loadAudio(song: song)
                    }
                }
                .onDelete(perform: deleteSong(indexes:))
            } else {
                ForEach(savedSongs) { song in
                    Button(song.artist + " - " + song.title) {
                        looper.loadAudio(song: song)
                        // TODO send the user back to LooperView()
                    }
                    .foregroundStyle(.foreground)
                }
                .onDelete(perform: deleteSong(indexes:))
            }
            Menu("Import",systemImage: "plus") {
                Button("Apple Music", systemImage: "music.note.square.stack",action: addSong)
                Button("Documents", systemImage: "folder", action: addDocument)
                Button("Videos", systemImage: "camera", action: addVideo)
            }
        }
        .sheet(item: $newDocument) { song in
            DocumentPicker(song: song)
        }
        .sheet(item: $newSong) { song in
            MusicPicker(song: song)
        }
        .sheet(item: $newVideo) { song in
            VideoPicker(song: song)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
        .searchable(text: $searchQuery,
                    placement: .automatic,
                    prompt: "Song or Artist Name")
        .textInputAutocapitalization(.never)
        .onChange(of: searchQuery){
            self.fetchSearchResults(for: searchQuery)
        }
        .navigationTitle("All Songs")
    }
    
    private func fetchSearchResults(for query: String){
        searchResults = savedSongs.filter { song in
            song.title
                .lowercased()
                .contains(query)
        }
    }
    
    private func addVideo(){
        let newVideo = Song(title: "demo audio", isSecure: false)
        context.insert(newVideo)
        self.newVideo = newVideo
    }
    private func addDocument(){
        let newDocument = Song(title: "demo audio", isSecure: true)
        context.insert(newDocument)
        self.newDocument = newDocument
    }
    private func addSong(){
        let newSong = Song(title: "demo audio", isSecure: false)
        context.insert(newSong)
        self.newSong = newSong
    }
    private func deleteSong(indexes: IndexSet){
        for i in indexes {
            context.delete(savedSongs[i])
        }
    }
}

struct Playlists: View {
    
    @Query private var playlists: [Playlist]
    @Environment(\.modelContext) private var context
    @State private var newPlaylist: Playlist!
    
    var body: some View {
        // splitview or stack? what's the difference?
        NavigationStack{
            List{
                ForEach(playlists) { playlist in
                    NavigationLink(playlist.name){
                        // add view of playlist here
                    }
                }
                Button("New Playlist", systemImage: "plus", action: addPlaylist)
            }
            .sheet(item: $newPlaylist){ playlist in
                NavigationStack{
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
