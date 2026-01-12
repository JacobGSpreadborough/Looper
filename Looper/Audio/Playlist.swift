//
//  Playlist.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/1/25.
//

import SwiftData

@Model
class Playlist: Identifiable {
    
    static let recents = Playlist(name: "Recents", songs: [Song.demoSong])
    
    var name: String
    var songs: [Song] = []
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, songs: [Song]) {
        self.name = name
        self.songs = songs
    }
    
    func prepend(song: Song) {
        // add element to the front of the array
        songs.insert(song, at: 0)
    }
    
    func append(song: Song) {
        songs.append(song)
    }
    
}
