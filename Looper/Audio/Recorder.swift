//
//  Recorder.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/12/25.
//

import AVFoundation
import Combine
import SwiftUI

class Recorder: NSObject, ObservableObject {
    
    @AppStorage("recordingCount") private var recordingCount: Int = 1

    private var recorder: AVAudioRecorder!
    private var session: AVAudioSession!
    
    @Published var isRecording: Bool = false
    @Published var hasRecording: Bool = false
    // TODO: add incremental or date-unique recording names
    @Published var recordingURL: URL!
    @Published var duration: TimeInterval = 0
    
    let settings = [
        AVFormatIDKey: Int(kAudioFormatLinearPCM),
        AVSampleRateKey: 48_000,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    override init() {
        super.init()
        setupSession()
    }
    
    func startRecording() {
        setupSession()
        
        //let format = DateFormatter()
        //format.dateFormat = "dd-MM-yyyy"
        //let dateString = format.string(from: Date())
        //let fileName = "New Recording [" + dateString + " " + recordingCount.description + "].wav"
        let fileName = "New Recording " + recordingCount.description + ".wav"
        // create a unique url for each recording
        recordingURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        print("recording to: \(String(describing: recordingURL))")
        do {
            recorder = try AVAudioRecorder(url: recordingURL, settings: settings)
            recorder.delegate = self
            // record() implicitly calls prepareToRecord()
            if recorder.record() {
                isRecording = true
            } else {
                fatalError("couldn't start recording")
            }
        } catch {
            print("could not initialize recorder \(error)")
        }
    }
    
    func stopRecording() {
        recorder.stop()
        isRecording = false
        hasRecording = true
        // increment static count
        // TODO: decrement on delete?
        recordingCount += 1
        try!session.setActive(false)
    }
    
    private func setupSession() {
        session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            print("could not start session \(error)")
        }
        AVAudioApplication.requestRecordPermission { granted in
            if granted {
                print("record permission granted")
            } else {
                print("record permission denied")
            }
        }
    }
}

extension Recorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recorder.stop()
        isRecording = false
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: (any Error)?) {
        if let error = error {
            print("recorder encode error \(error)")
        }
    }
}
