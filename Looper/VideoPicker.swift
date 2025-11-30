//
//  VideoPicker.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/30/25.
//

import SwiftUI
import UIKit
import PhotosUI

struct VideoPicker: UIViewControllerRepresentable {
    
    @Binding var video: UIImage?
    
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
            guard let video = results.first?.itemProvider else { return }
            // TODO get audio from videos
        }
    }
}
