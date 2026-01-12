//
//  Playlists.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/9/25.
//

import SwiftUI
import SwiftData

struct Playlists: View {
    @ObservedObject var looper: Looper
    @Binding var currentTab: Int
    
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
                ForEach(playlists) { playlist in
                    NavigationLink(playlist.name){
                        PlaylistSongView(playlist: playlist, looper: looper, currentTab: $currentTab)
                    }
                }
                .onDelete(perform: deletePlaylist)
            }
            Button("New Playlist", systemImage: "plus") {
                nameDialogShowing = true
            }
        }
        // present name dialog
        // create playlist and present song list once a name is entered
        .alert("Playlist name", isPresented: $nameDialogShowing) {
            TextField("Enter playlist title", text: $newName)
            Button("Confirm") {
                songPickerShowing = true
            }
            Button("Cancel",role: .cancel){}
        }
        // present song list
        .sheet(isPresented: $songPickerShowing){
            NavigationView {
                SongList(selection: $selection, editMode: .active, deletable: false)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing){
                            // create and store new playlist
                            Button("Done"){
                                createPlaylist(name: newName, songs: selection)
                            }
                        }
                        ToolbarItem(placement: .topBarLeading){
                            Button("Cancel", role: .cancel){
                                songPickerShowing = false
                            }
                        }
                    }
            }
        }
        .onChange(of: selection) {
            print("song selected")
        }
        .navigationTitle("Playlists")
    }
    
    private func createPlaylist(name: String, songs: Set<Song>) {
        
        let newPlaylist = Playlist(name: name)
        newPlaylist.songs.append(contentsOf: songs)
        
        context.insert(newPlaylist)
        do {
            try context.save()
        } catch {
            print("save failed \(error)")
        }
        
        songPickerShowing = false
        newName = "New Playlist"
    }
    
    private func deletePlaylist(indexes: IndexSet) {
        for i in indexes {
            context.delete(playlists[i])
        }
    }
    
}
