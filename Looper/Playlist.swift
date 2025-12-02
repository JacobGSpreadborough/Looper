//
//  Playlist.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/1/25.
//

import SwiftData

@Model
class Playlist: Identifiable {
    var name: String
    var songs: [Song]
    
    init(name: String, songs: [Song]) {
        self.name = name
        self.songs = songs
    }
}
