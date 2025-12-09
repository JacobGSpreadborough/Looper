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


struct AllSongs: View {
    
    @State private var documentPickerShowing: Bool = false
    @State private var musicPickerShowing: Bool = false
    @State private var videoPickerShowing: Bool = false
    
    @Binding var looper: Looper
    
    @State var menuShowing: Bool = false
    @State var selection: Set<Song> = []
    
    @Query var savedSongs: [Song]
    @Environment(\.modelContext) var context
    
    var body: some View {
        
        NavigationStack {
            SongList(selection: $selection, editMode: .inactive, deletable: true)
        }
        .onChange(of: selection) {
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

struct Playlists: View {
    @Binding var looper: Looper
    
    @Query private var playlists: [Playlist]
    //@Query private var songs: [Song]
    @State private var selection: Set<Song> = []
    @Environment(\.modelContext) private var context
    @State private var newPlaylist: Playlist!
    @State private var songPickerShowing: Bool = false
    @State private var nameDialogShowing: Bool = false
    @State private var newName: String = "New Playlist"
    
    var body: some View {
        NavigationStack{
            List{
                // TODO just do this in the list
                ForEach(playlists) { playlist in
                    NavigationLink(playlist.name){
                        PlaylistSongView(playlist: playlist, looper: $looper)
                    }
                }
            }
            Button("New Playlist", systemImage: "plus") {
                    nameDialogShowing = true
            }
        }
        // present name dialog
        // create playlist and present song list once a name is entered
        .alert("playist name", isPresented: $nameDialogShowing) {
            TextField("Enter playlist title", text: $newName)
            Button("Confirm") {
                songPickerShowing = true
               // createPlaylist(name: newName)
            }
            Button("Cancel",role: .cancel){}
        }
        // present song list
        .sheet(isPresented: $songPickerShowing){
            // TODO: add cancel / done button
            NavigationView {
                SongList(selection: $selection, editMode: .active, deletable: false)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing){
                            // create new playlist, add songs, insert into storage
                            Button("Done"){
                                let newPlaylist = Playlist(name: newName)
                                newPlaylist.songs.append(contentsOf: selection)
                                context.insert(newPlaylist)
                                do {
                                    try context.save()
                                } catch {
                                    fatalError("save failed")
                                }
                                // dismiss song list sheet
                                songPickerShowing = false
                                // reset new name variable
                                newName = "New Playlist"
                            }
                        }
                        ToolbarItem(placement: .topBarLeading){
                            Button("Cancel", role: .cancel){}
                        }
                    }
            }
        }
            
        .onChange(of: selection) {
            print("song selected")
        }
        .navigationTitle("Playlists")
    }
    
    private func createPlaylist(name: String) {
        print("creating playlist")
        newPlaylist = Playlist(name: name)
        context.insert(newPlaylist)
        do{
            try context.save()
        } catch {
            fatalError("save failed")
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
