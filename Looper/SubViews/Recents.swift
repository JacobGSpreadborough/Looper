//
//  Recents.swift
//  Looper
//
//  Created by Jacob Spreadborough on 1/12/26.
//
import SwiftUI
import SwiftData

struct Recents: View {
    @ObservedObject var looper: Looper
    @Binding var currentTab: Int
    
    var body: some View {
        NavigationStack{
            PlaylistSongView(playlist: Playlist.recents, looper: looper, currentTab: $currentTab)
        }
    }

}

#Preview {
    
}
