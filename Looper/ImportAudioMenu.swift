//
//  ImportAudioMenu.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/30/25.
//

import UIKit
import SwiftUI
import MediaPlayer
import PhotosUI
internal import UniformTypeIdentifiers

struct ImportAudioMenu: View {
    @Binding var musicPickerShowing: Bool
    @Binding var documentPickerShowing: Bool
    @Binding var videoPickerShowing: Bool
    var body: some View {
        Menu("Import Audio"){
            CustomListButton(image: "music.note.square.stack", text: "Apple Music",action: {
                    musicPickerShowing = true
                })
            CustomListButton(image: "folder", text: "Documents", action: {
                documentPickerShowing = true
            })
            CustomListButton(image: "camera", text: "Videos", action: {
                videoPickerShowing = true
            })
            CustomListButton(image: "waveform.mid", text: "Voice memos", action: {
                // TODO implement this
            })
            Button("Cancel"){}
        }
    }
}

struct CustomListButton: View{
    var image: String
    var text: String
    var action: () -> Void
    var body: some View {
        Button(
            action: action,
            label: {
                HStack{
                    Image(systemName: image)
                    Text(text)
            }
        })
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    
    @Binding var looper: Looper

    func makeUIViewController(context: Context) -> some UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        documentPicker.allowsMultipleSelection = false
        documentPicker.delegate = context.coordinator
        return documentPicker
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(_ parent: DocumentPicker){
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let documentURL = urls.first else {
                print("document selection failed")
                return
            }
            
            if (documentURL.startAccessingSecurityScopedResource()) {
                parent.looper.loadAudio(url: documentURL)
            } else {
                print("access error")
                return
            }
            
            documentURL.stopAccessingSecurityScopedResource()
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // TODO probably should do something maybe IDK
        }
    }
    
}


struct MusicPicker: UIViewControllerRepresentable {
    
    @Binding var looper: Looper
    
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
                    parent.looper = Looper(url: url)
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

struct VideoPicker: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .videos
        config.selectionLimit = 1
        let videoPicker = PHPickerViewController(configuration: config)
        videoPicker.delegate = context.coordinator
        return videoPicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate{
        var parent: VideoPicker
        
        init(_ parent: VideoPicker){
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated:true)
            guard (results.first?.itemProvider) != nil else { return }
            // TODO get audio from videos
        }
    }
}
