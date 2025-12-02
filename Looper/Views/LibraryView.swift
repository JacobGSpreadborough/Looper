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
    @State private var newSong: Song!
    @State private var newDocument: Song!
    @State private var newVideo: Song!
    
    @Binding var looper: Looper
    
    @State var menuShowing: Bool = false
    @State var selection: Song!
    
    @Query var savedSongs: [Song]
    @Environment(\.modelContext) var context
    
    var body: some View {
        
        VStack {
            SongList(selection: $selection, looper: $looper)
            .onChange(of: selection) {
                looper.loadAudio(song: selection)

            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button("Add Song", systemImage: "plus") {
                    menuShowing = true
                }
            })
        }
        .sheet(isPresented: $menuShowing) {
            //TODO this sucks
        List{
            Button("Apple Library", systemImage: "music.note.square.stack", action: addSong)
            Button("Documents",systemImage: "folder",action:addDocument)
            Button("videos", systemImage: "camera",action:addVideo)
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
        .navigationTitle("All Songs")
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
