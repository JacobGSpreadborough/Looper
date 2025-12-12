//
//  Looper.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/10/25.
//

import AudioKit
import Waveform
import Foundation
import AVFAudio
import MediaPlayer
import Combine

class Looper: ObservableObject {
    
    private let engine = AudioEngine()
    var player: AudioPlayer!
    var speedPitch: TimePitch!
    var recorder: NodeRecorder!
    var EQSix: MultiBandEQ!
    
    var samples: SampleBuffer!
    // start point and duration in samples rather than seconds
    var loopStartSample: Int!
    var loopLengthSample: Int!
    // prevent loops from being too short
    let MINIMUM_LOOP_LENGTH: TimeInterval = 1
    // steps above or below original
    @Published var pitch: AUValue = 0
    // we do not start playing automatically
    @Published var isPlaying: Bool = false
    @Published var isLooping: Bool = false
    @Published var duration: Double!
    
    @Published var fileName: String!
    
    init(song: Song) {
        
        print("looper initializing")
        
        requestMic()
        setupSession()
        setupChain()
        
        player = AudioPlayer()
        
        player.completionHandler = completionHandler
        
        let settings = AVAudioFormat(standardFormatWithSampleRate: 48_000, channels: 2) ?? AVAudioFormat()
        recorder.recordFormat = settings
        
        loadAudio(song: song)
        
        attachPlayer()
    }
    
    private func attachPlayer() {
        player.isEditTimeEnabled = true;
        player.isLooping = false
        player.volume = 0.5
        
        EQSix = MultiBandEQ(input: player)
        
        speedPitch = TimePitch(EQSix)

        engine.output = speedPitch
        try!engine.start()
    }
    
    open func loadAudio(song: Song) {
        stop()
        
        let url = resolveBookmark(from: song.bookmark!, isSecure: song.isSecure)!
        let file = try!AVAudioFile(forReading: url)
        
        // TODO handle case of loading song with only 1 channel
        if(player.outputFormat.sampleRate != file.fileFormat.sampleRate) {
            print("sample rate mismatch, reinitializing player")
            Settings.audioFormat = AVAudioFormat(standardFormatWithSampleRate: file.fileFormat.sampleRate, channels: 2) ?? AVAudioFormat()
            player = AudioPlayer(file: file, buffered: true)
            attachPlayer()
        } else {
            try!player.load(file: file,buffered: true, preserveEditTime: false)
        }
        
        // reset speed
        //speedPitch.rate = 0
        //changeSpeed(percent: 100)
        
        duration = player.duration

        samples = SampleBuffer(samples: file.floatChannelData()![0])
        loopStartSample = Int(player.editStartTime * player.outputFormat.sampleRate)
        loopLengthSample = Int((player.editEndTime - player.editStartTime) * player.outputFormat.sampleRate)
        
        fileName = song.artist + " - " + song.title
    }
    
    func completionHandler() {
        stop()
    }
    
    func toggleRecording() {
        if recorder.isRecording {
            recorder.stop()
        } else {
            do {
                try recorder.record()
            } catch {
                print("recorder could not start")
            }
        }
    }
    func togglePlaying() {
        if(player.isPlaying) {
            player.stop()
        } else if let file = recorder.audioFile {
            player.file = file
            player.start()
        }
    }
    
    private func setupSession() {
        // set up session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord, options: [.defaultToSpeaker, .allowBluetoothHFP])
            try session.setActive(true)
        } catch {
            print("session setup failure")
        }
    }
    private func setupChain(){
        // set up chain
        guard let input = engine.input else {
            fatalError("no mic available")
        }
        do {
            recorder = try NodeRecorder(node: input)
        } catch {
            fatalError("could not set up recorder")
        }
    }
    private func requestMic(){
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async {
                guard granted else {
                    print("permission not granted")
                    return
                }
            }
        }
    }
   
    open func changePitch(steps: AUValue) {
        if(pitch <= 24 && pitch >= -24) {
            pitch += steps
            speedPitch.pitch = pitch * 100
        }
    }
    
    open func changeSpeed(percent: AUValue) {
        speedPitch.rate = percent
    }
    
    open func setLoopStart(startTime: TimeInterval) {
        // prevent loop with length <= 0
        if(startTime >= player.editEndTime) {
            player.editEndTime = player.duration
        } else{
            player.editStartTime = startTime
        }
        // adjust start and end variables for the waveform display
        loopStartSample = Int(player.editStartTime * player.outputFormat.sampleRate)
        loopLengthSample = Int((player.editEndTime - player.editStartTime) * player.outputFormat.sampleRate)
    }
    
    open func setLoopEnd(endTime: TimeInterval) {
        // prevent loop from being too short
        if((player.editEndTime - player.editStartTime) < MINIMUM_LOOP_LENGTH) {
            player.editEndTime = player.editStartTime + MINIMUM_LOOP_LENGTH
        } else{
            // keep the edit within the bounds of the file
            if(endTime > player.duration || endTime < 0) {
                player.editEndTime = player.duration
            } else{
                player.editEndTime = endTime
            }
        }
        // adjust start and end variables for the waveform display
        loopLengthSample = Int((player.editEndTime - player.editStartTime) * player.outputFormat.sampleRate)
    }
    
    open func enableLooping() {
        if(!player.isLooping) {
            isLooping = true
            player.isLooping = true
        } else {}
    }
    
    open func disableLooping() {
        if(player.isLooping) {
            isLooping = false
            // reset the loop, this prevents undefined behavior when the user moves the slider out of the loop
            player.editEndTime = player.duration
            player.isLooping = false
        } else {}
    }
    
    open func play(){
        isPlaying = true
        player.play()
    }
    
    open func pause() {
        isPlaying = false
        player.pause()
    }
    
    open func stop() {
        isPlaying = false
        player.stop()
    }

    open func seek(time: TimeInterval) {
        if(time < player.editStartTime) {
            player.editStartTime = time
        }
        if(time > player.editEndTime) {
            player.editEndTime = player.duration
        }
        player.seek(time:time - player.editStartTime)
    }


};
