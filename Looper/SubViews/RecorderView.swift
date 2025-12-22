//
//  RecorderView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/13/25.
//

import SwiftUI
import SwiftData
import Combine

struct RecorderView: View {
    
    @Query private var songs: [Song]
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var recorder: Recorder
    
    @State var recordingDuration: TimeInterval = 0
    @State var recordingTimer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack{
            Text(Utils.timeFormatter(time: recordingDuration))
                .onReceive(recordingTimer) { _ in
                    recordingDuration += 0.01
                }
                .monospacedDigit()
                .padding()
            Button("record") {
                if !recorder.isRecording {
                    // start timer and recorder
                    self.recordingTimer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
                    recorder.startRecording()
                } else {
                    // stop timer and recorder
                    self.recordingTimer.upstream.connect().cancel()
                    recorder.stopRecording()
                    // dismiss the sheet and open the alert to enter recording name
                    dismiss.callAsFunction()
                    do {
                        let data = try recorder.recordingURL.bookmarkData()
                        let title = recorder.recordingURL.lastPathComponent
                        // create and insert song from recording, save context
                        let newSong = Song(title: title, artist: "User", bookmark: data, isSecure: false)
                        context.insert(newSong)
                        try context.save()
                    } catch {
                        print("song creation failed \(error)")
                    }
                }
            }
        }
        .onAppear(){
            // stop timer on appear
            self.recordingTimer.upstream.connect().cancel()
        }
    }
}

#Preview {
    RecorderView(recorder: Recorder())
}
