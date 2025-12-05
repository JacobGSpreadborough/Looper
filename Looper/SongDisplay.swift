//
//  SongDisplay.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/3/25.
//

import SwiftUI

struct SongDisplay: View {
    var song: Song
    var body: some View {
        let defaultImageData = UIImage(named: "default")!.pngData()!
        let image = UIImage(data: (song.imageData ?? defaultImageData), scale: 20)!
        HStack {
            Image(uiImage: image)
            Text(song.artist + " - " + song.title)
        }
    }
}
