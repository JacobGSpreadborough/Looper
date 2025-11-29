//
//  DocumentPicker.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/29/25.
//

import UIKit
import SwiftUI
internal import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    
    @Binding var song: URL?
    
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
            guard let song = urls.first else {
                print("document selection failed")
                return
            }
            print("selected: \(song)")
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // TODO probably should do something maybe IDK
        }
    }
    
}
