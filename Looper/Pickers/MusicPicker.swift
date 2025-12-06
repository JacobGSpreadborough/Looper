//
//  MusicPicker.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/2/25.
//

import SwiftUI
import SwiftData
import MediaPlayer
import UIKit

struct MusicPicker: UIViewControllerRepresentable {
    
    @Environment(\.modelContext) private var context
    @Query var songs: [Song]
    
    func makeUIViewController(context: Context) -> some MPMediaPickerController {
        let picker = MPMediaPickerController(mediaTypes: .music)
        
        picker.allowsPickingMultipleItems = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MPMediaPickerControllerDelegate {
        var parent: MusicPicker
        
        init(_ parent: MusicPicker) {
            self.parent = parent
        }
        // TODO app crashes when selecting a song that isn't downloaded
        func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
            
            for mediaItem in mediaItemCollection.items {
                guard let url = mediaItem.assetURL else {
                    print("song does not have URL")
                    return
                }
                do {
                    let data = try url.bookmarkData()
                    if let artwork = mediaItem.artwork {
                        if let image = artwork.image(at: artwork.bounds.size) {
                            let newSong = Song(title: mediaItem.title!, artist: mediaItem.artist!, bookmark: data, isSecure: false)
                            newSong.imageData = image.pngData()
                            parent.context.insert(newSong)
                            try parent.context.save()
                        }
                    }
                    
                    
                } catch {
                    fatalError("couldn't create bookmark from url")
                }

            }
            mediaPicker.dismiss(animated:true)
        }
        
        func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
            mediaPicker.dismiss(animated:true)
        }
    }
}
