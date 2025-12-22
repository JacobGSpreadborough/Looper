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
    
    private var engine: AudioEngine
    var player: AudioPlayer!
    var speedPitch: TimePitch!
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
        
        engine = AudioEngine()
        
        print("looper initializing")
        
        player = AudioPlayer()
        
        player.completionHandler = completionHandler
        
        loadAudio(song: song)
        
        attachPlayer()
    }
    
    private func attachPlayer() {
        
        player.completionHandler = completionHandler
        
        player.isEditTimeEnabled = true;
        player.isLooping = false
        player.volume = 0.5
        
        EQSix = MultiBandEQ(input: player)
        
        speedPitch = TimePitch(EQSix)

        engine.output = speedPitch
        do {
            try engine.start()
        } catch {
            print("engine did not start \(error)")
        }
    }
    
    open func loadAudio(song: Song) {
        stop()
        engine.stop()
        
        setupSession()
        
        let url = resolveBookmark(from: song.bookmark!, isSecure: song.isSecure)!
        let file = try!AVAudioFile(forReading: url)
        //  set everything to 48kHz mono
        Settings.audioFormat = AVAudioFormat(standardFormatWithSampleRate: 48_000, channels: 2) ?? AVAudioFormat()
        
        player = AudioPlayer(file: file, buffered: true)
        attachPlayer()
        
        duration = player.duration

        samples = SampleBuffer(samples: file.floatChannelData()![0])
        loopStartSample = Int(player.editStartTime * player.outputFormat.sampleRate)
        loopLengthSample = Int((player.editEndTime - player.editStartTime) * player.outputFormat.sampleRate)
        
        fileName = song.artist + " - " + song.title
    }
    
    func setupSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback)
            try session.setActive(true)
        } catch {
            print("session setup failed \(error)")
        }
    }
    
    func completionHandler() {
        stop()
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
        do{
            try engine.start()
        } catch {
            print("could not start engine \(error)")
        }
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
