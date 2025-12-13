//
//  RecorderView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/13/25.
//

import SwiftUI
import SwiftData

struct RecorderView: View {
    
    @Query private var songs: [Song]
    @Environment(\.modelContext) private var context
    
    @ObservedObject var recorder: Recorder
    
    var body: some View {
        Button("record") {
            if !recorder.isRecording {
                recorder.startRecording()
            } else {
                recorder.stopRecording()
                do {
                    let data = try recorder.recordingURL.bookmarkData()
                    // TODO: custom title
                    let title = recorder.recordingURL.lastPathComponent
                    let newSong = Song(title: title, artist: "User", bookmark: data, isSecure: false)
                    context.insert(newSong)
                    try context.save()
                } catch {
                    print("song creation failed \(error)")
                }
            }
        }
    }
}

#Preview {
    RecorderView(recorder: Recorder())
}
