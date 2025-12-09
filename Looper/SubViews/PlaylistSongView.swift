//
//  PlaylistSongView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/9/25.
//

import SwiftUI

struct PlaylistSongView: View {
    var playlist: Playlist
    @Binding var looper: Looper
    @State var selection: Song?
    var body: some View {
        List(selection: $selection){
            ForEach(playlist.songs) { song in
                SongDisplay(song: song)
                    .tag(song)
            }
            .onChange(of: selection) {
                looper.loadAudio(song: selection!)
            }
        }
    }
}
