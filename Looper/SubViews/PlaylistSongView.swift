//
//  PlaylistSongView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/9/25.
//

import SwiftUI

struct PlaylistSongView: View {
    var playlist: Playlist
    @ObservedObject var looper: Looper
    @State var selection: Song?
    @Binding var currentTab: Int
    var body: some View {
        List(selection: $selection){
            ForEach(playlist.songs) { song in
                SongDisplay(song: song)
                    .tag(song)
            }
            .onChange(of: selection) {
                currentTab = 0
                looper.loadAudio(song: selection!)
            }
        }
        .navigationTitle(playlist.name)
    }
}
