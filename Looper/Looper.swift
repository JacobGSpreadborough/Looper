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

class Looper {
    private let engine = AudioEngine()
    var samples: SampleBuffer!
    // start point and duration in samples rather than seconds
    var loopStartSample: Int!
    var loopLengthSample: Int!
    // prevent loops from being too short
    let MINIMUM_LOOP_LENGTH: TimeInterval = 1
    var player: AudioPlayer!
    var speedPitch: TimePitch!
    // steps above or below original
    var pitch: AUValue = 0
    var EQ60: LowShelfFilter!
    var EQ150: ParametricEQ!
    var EQ400: ParametricEQ!
    var EQ1k: ParametricEQ!
    var EQ2k4: ParametricEQ!
    var EQ10k: HighShelfFilter!
    // we do not start playing automatically
    var isPlaying: Bool = false
    var isLooping: Bool = false
    var duration: Double!
    
    var fileName: String!
    
    init(song: Song) {
        
        print("looper initializing")
        
        player = AudioPlayer()
        
        loadAudio(song: song)
        
        attachPlayer()
    }
    
    private func attachPlayer() {
        player.isEditTimeEnabled = true;
        player.isLooping = false
        player.volume = 0.5
        
        EQ60 = LowShelfFilter(player, cutoffFrequency: 60, gain: 0)
        EQ150 = ParametricEQ(EQ60, centerFreq: 150, q: 1, gain: 0)
        EQ400 = ParametricEQ(EQ150, centerFreq: 400,  q: 1, gain: 0)
        EQ1k = ParametricEQ(EQ400, centerFreq: 1000, q: 1, gain: 0)
        EQ2k4 = ParametricEQ(EQ1k, centerFreq: 2400,  q: 1, gain: 0)
        EQ10k = HighShelfFilter(EQ2k4, cutOffFrequency: 10000, gain: 0)
        
        speedPitch = TimePitch(EQ10k)
        
        engine.output = speedPitch
        try!engine.start()
    }
    
    open func loadAudio(song: Song) {
        stop()
        
        let url = resolveBookmark(from: song.bookmark!, isSecure: song.isSecure)!
        let file = try!AVAudioFile(forReading: url)
        
        // TODO handle case of loading song with only 1 channel
        if(player.outputFormat.sampleRate != file.fileFormat.sampleRate) {
            player = AudioPlayer(file: file, buffered: true)
            attachPlayer()
        } else {
            try!player.load(file: file,buffered: true)
        }
        
        duration = player.duration

        samples = SampleBuffer(samples: file.floatChannelData()![0])
        loopStartSample = Int(player.editStartTime * player.outputFormat.sampleRate)
        loopLengthSample = Int((player.editEndTime - player.editStartTime) * player.outputFormat.sampleRate)
        
        fileName = song.artist + " - " + song.title
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

    open func setEQ60(gain: Float) {
        EQ60.gain = gain
    }
    open func setEQ150(gain: Float) {
        EQ150.gain = gain
    }
    open func setEQ400(gain: Float) {
        EQ400.gain = gain
    }
    open func setEQ1k(gain: Float) {
        EQ1k.gain = gain
    }
    open func setEQ2k4(gain: Float) {
        EQ2k4.gain = gain
    }
    open func setEQ10k(gain: Float) {
        EQ10k.gain = gain
    }
};
