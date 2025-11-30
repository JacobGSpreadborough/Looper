//
//  MusicPicker.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/29/25.
//

import UIKit
import MediaPlayer
import SwiftUI

struct MusicPicker: UIViewControllerRepresentable {
    
    @Binding var song: MPMediaItem?
    
    func makeUIViewController(context: Context) -> some MPMediaPickerController {
        let picker = MPMediaPickerController(mediaTypes: .music)
        picker.allowsPickingMultipleItems = false
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
        
        func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
            guard let song = mediaItemCollection.items.first else {
                print("song selection failed")
                return
            }
            if let url = song.assetURL {
                if(url.startAccessingSecurityScopedResource()){
                    looper = Looper(url: url)
                }
                url.stopAccessingSecurityScopedResource()
            }
            mediaPicker.dismiss(animated:true)
        }
        
        func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
            mediaPicker.dismiss(animated:true)
        }
    }
}
