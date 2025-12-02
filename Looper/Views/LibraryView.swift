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
                NavigationLink(destination: FavoriteSongs(), label: {
                    Label("Favorites", systemImage: "star")
                })
                NavigationLink(destination: RecentSongs(), label: {
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
    
    var body: some View {
        List{
            if savedSongs.isEmpty {
                // TODO make this small and gray
                Text("No saved songs")
            }
            ForEach(savedSongs) { song in
                Button(song.artist + " - " + song.title) {
                    looper.loadAudio(song: song)
                    // TODO send the user back to LooperView()
                }
                .foregroundStyle(.foreground)
            }
            .onDelete(perform: deleteSong(indexes:))
            Menu("Import",systemImage: "plus") {
                Button("Apple Music", systemImage: "music.note.square.stack",action: addSong)
                Button("Documents", systemImage: "folder", action: addDocument)
                Button("Videos", systemImage: "camera", action: addVideo)
            }
        }
        .navigationTitle("All Songs")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
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
struct FavoriteSongs: View {
    var body: some View {
        List{
            
        }
        .navigationTitle("Favorites")
    }

}
struct RecentSongs: View {
    var body: some View {
        List{
            
        }
        .navigationTitle("Recents")
    }

}
struct Playlists: View {
    var body: some View {
        List{
            Button("Add Playlist", systemImage: "plus") {
                
            }
        }
        .navigationTitle("Playlists")
    }
}
