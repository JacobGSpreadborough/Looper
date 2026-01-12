//
//  Song.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/1/25.
//

import SwiftData
import AVFAudio

@Model
class Song {
    
    var title: String
    var artist: String
    // prevent duplicate files
    @Attribute(.unique) var bookmark: Data?
    var isSecure: Bool
    var displayTitle: String {
        artist + " - " + title
    }
    var searchString: String {
        artist + title
    }
    var imageData: Data?
    
    init(title: String = "", artist: String = "", bookmark: Data? = nil, isSecure: Bool) {
        self.title = title
        self.artist = artist
        self.bookmark = bookmark
        self.isSecure = isSecure
    }

    private init(url: URL) {
        self.title = "track 0"
        self.artist = "demo"
        self.bookmark = try!url.bookmarkData()
        self.isSecure = false
    }
    
    static let demoSong = Song(url: Bundle.main.url(forResource: "demo audio", withExtension: "mp3")!)
    
}
