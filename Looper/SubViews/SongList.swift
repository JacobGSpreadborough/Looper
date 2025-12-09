//
//  SongList.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/2/25.
//

import SwiftUI
import SwiftData

struct SongList: View {
    // allow for multiple selection
    @Binding var selection: Set<Song>
    // SwiftData storage
    @Query private var savedSongs: [Song]
    @Environment(\.modelContext) private var context
    //
    @State var editMode: EditMode
    let deletable: Bool
    // search utility
    @State private var searchQuery: String = ""
    @State private var searchResults: [Song] = []
    private var isSearching: Bool {
        return !searchQuery.isEmpty
    }
    
    var body: some View {
        List(selection: $selection) {
            if !isSearching {
                ForEach(savedSongs) { song in
                    SongDisplay(song: song)
                        .tag(song)
                }
                // toggle deletion based on user input
                .onDelete(perform: deleteSong)
                .deleteDisabled(!deletable)
            } else {
                ForEach(searchResults) { song in
                    SongDisplay(song: song)
                        .tag(song)
                }
                // toggle deletion based on user input
                .onDelete(perform: deleteSong)
                .deleteDisabled(!deletable)
            }
        }
        // toggle editing mode based on user input
        .environment(\.editMode, $editMode)
        .searchable(text: $searchQuery,
                    placement: .automatic,
                    prompt: "Song or Artist Name")
        .textInputAutocapitalization(.never)
        .onChange(of: searchQuery){
            self.fetchSearchResults(for: searchQuery)
        }
    }
    
    private func deleteSong(indexes: IndexSet){
        for i in indexes {
            context.delete(savedSongs[i])
        }
    }
    private func fetchSearchResults(for query: String){
        searchResults = savedSongs.filter { song in
            song.searchString
                .lowercased()
                .contains(query)
        }
    }
}
