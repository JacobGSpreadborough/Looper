//
//  SongList.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/2/25.
//

import SwiftUI
import SwiftData

struct SongList: View {
    @Binding var selection: Song?
    @Binding var looper: Looper
    
    @Query var savedSongs: [Song]
    @Environment(\.modelContext) var context
    
    @State var searchQuery: String = ""
    @State var searchResults: [Song] = []
    var isSearching: Bool {
        return !searchQuery.isEmpty
    }
    var body: some View {
       
        List(selection: $selection) {
            if !isSearching {
                ForEach(savedSongs) { song in
                    SongDisplay(song: song)
                        .tag(song)
                }
                .onDelete(perform: deleteSong)
            } else {
                ForEach(searchResults) { song in
                    SongDisplay(song: song)
                        .tag(song)
                }
                .onDelete(perform: deleteSong(indexes:))
            }
        }
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
