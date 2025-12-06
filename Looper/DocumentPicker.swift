//
//  DocumentPicker.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/2/25.
//

import SwiftUI
import SwiftData
internal import UniformTypeIdentifiers


struct DocumentPicker: UIViewControllerRepresentable {
    
    //let song: Song
    @Environment(\.modelContext) private var context
    @Query var songs: [Song]

    func makeUIViewController(context: Context) -> some UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        documentPicker.allowsMultipleSelection = true
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
            
            for url in urls {
                if(url.startAccessingSecurityScopedResource()) {
                    //parent.song.artist = "User"
                    //parent.song.title = url.lastPathComponent
                    do{
                        let data = try url.bookmarkData( includingResourceValuesForKeys: nil, relativeTo: nil)
                        let newSong = Song(title: url.lastPathComponent, artist: "User", bookmark: data, isSecure: true)
                        parent.context.insert(newSong)
                        try parent.context.save()
                    } catch{
                        fatalError("bookmark creation failed")
                    }
                } else {
                    print("access error")
                    return
                }
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // TODO probably should do something maybe IDK
        }
    }
    
}
