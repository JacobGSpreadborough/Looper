//
//  Playlist.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/1/25.
//

struct Playlist: Identifiable {
    var name: String
    var songs: [Song]
    var id: String{name}
}
