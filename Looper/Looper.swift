//
//  Looper.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/10/25.
//

import AudioKit
import Waveform
import AVFAudio

class Looper {
    private let engine = AudioEngine()
    var samples: SampleBuffer
    // start point and duration in samples rather than seconds
    var loopStartSample: Int
    var loopLengthSample: Int
    // prevent loops from being too short
    let MINIMUM_LOOP_LENGTH: TimeInterval = 1
    var player: AudioPlayer!
    var speedPitch: TimePitch!
    // steps above or below original
    var pitch: AUValue = 0
    var mixer: Mixer!
    var EQ60: ParametricEQ!
    var EQ150: ParametricEQ!
    var EQ400: ParametricEQ!
    var EQ1k: ParametricEQ!
    var EQ2k4: ParametricEQ!
    var EQ15k: ParametricEQ!
    // we do not start playing automatically
    var isPlaying: Bool = false
    var isLooping: Bool = false
    var duration: Double
    
    // TODO select song from settings menu
    let fileName:String = "Miles Davis Quintet - It Never Entered My Mind"
    
    init() {
        
        let file = try! AVAudioFile(forReading: Bundle.main.url(forResource: fileName, withExtension: "mp3")!)
        
        player = AudioPlayer(file: file, buffered: true)
        duration = player.duration
        player.isEditTimeEnabled = true;
        player.isLooping = false
        player.volume = 0.5
        
        EQ60 = ParametricEQ(player, centerFreq: 60, q: 0.1, gain: 0)
        EQ150 = ParametricEQ(player, centerFreq: 150, q: 0.1, gain: 0)
        EQ400 = ParametricEQ(player, centerFreq: 400,  q: 0.1, gain: 0)
        EQ1k = ParametricEQ(player, centerFreq: 1000, q: 0.1, gain: 0)
        EQ2k4 = ParametricEQ(player, centerFreq: 2400,  q: 0.1, gain: 0)
        EQ15k = ParametricEQ(player, centerFreq: 15000,  q: 0.1, gain: 0)
        
        mixer = Mixer(EQ60,EQ150,EQ400,EQ1k,EQ2k4,EQ15k)
        
        speedPitch = TimePitch(mixer)
        
        engine.output = speedPitch
        try!engine.start()
        
        samples = SampleBuffer(samples: file.floatChannelData()![0])
        loopStartSample = Int(player.editStartTime * player.outputFormat.sampleRate)
        loopLengthSample = Int((player.editEndTime - player.editStartTime) * player.outputFormat.sampleRate)
        
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
        print("seeking to \(time)")
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
    open func setEQ15k(gain: Float) {
        EQ15k.gain = gain
    }
    
};
