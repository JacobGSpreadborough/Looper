//
//  LibraryView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/1/25.
//

import SwiftUI
import AVFAudio

struct Song: Identifiable {
    let title: String
    let artist: String
    let file: AVAudioFile
    let url: URL
    let image: Image?
    var id: String{title}
}

struct Playlist: Identifiable {
    let name: String
    let songs: [Song]
    var id: String{name}
}

struct LibraryView: View {
    @Binding var looper: Looper
    @State var savedSongs: [Song] = []
    @State var playlists: [Playlist] = []
    @State var musicPickerShowing: Bool = false
    @State var documentPickerShowing: Bool = false
    @State var videoPickerShowing: Bool = false
    var body: some View {
        NavigationStack{
            List{
                NavigationLink(destination: AllSongs(savedSongs: $savedSongs, looper: $looper), label: {
                    Label("All", systemImage: "line.horizontal.3")
                })
                NavigationLink(destination: Playlists(playlists: $playlists), label: {
                    Label("Playlists", systemImage: "music.note.square.stack")
                })
                NavigationLink(destination: FavoriteSongs(), label: {
                    Label("Favorites", systemImage: "star")
                })
                NavigationLink(destination: RecentSongs(), label: {
                    Label("Recents", systemImage: "clock")
                })
                ImportAudioMenu(musicPickerShowing: $musicPickerShowing, documentPickerShowing: $documentPickerShowing, videoPickerShowing: $videoPickerShowing)
                    .sheet(isPresented: $documentPickerShowing, content:{DocumentPicker(savedSongs: $savedSongs)})
                    .sheet(isPresented: $musicPickerShowing, content: {MusicPicker(savedSongs: $savedSongs)})
                    .sheet(isPresented: $videoPickerShowing, content: {VideoPicker()})
            }
        }
    }
}


struct AllSongs: View {
    @Binding var savedSongs: [Song]
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
        }
        .navigationTitle("All Songs")
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
    @Binding var playlists: [Playlist]
    var body: some View {
        List{
            ForEach(playlists) { playlist in
                
            }
            Button("Add Playlist", systemImage: "plus") {
                
            }
        }
        .navigationTitle("Playlists")
    }
}
