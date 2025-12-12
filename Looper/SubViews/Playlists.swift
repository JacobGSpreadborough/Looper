//
//  Playlists.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/9/25.
//

import SwiftUI
import SwiftData

struct Playlists: View {
    @Binding var looper: Looper
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
