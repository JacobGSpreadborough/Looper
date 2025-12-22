//
//  MultiBandEQ.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/12/25.
//

import AudioKit
import Combine
import SwiftUI
import AVFAudio

class MultiBandEQ: ObservableObject, Node {
    
    var connections: [any AudioKit.Node] = []
    
    var avAudioNode: AVAudioNode
    
    var EQ60: LowShelfFilter!
    var EQ150: ParametricEQ!
    var EQ400: ParametricEQ!
    var EQ1k: ParametricEQ!
    var EQ2k4: ParametricEQ!
    var EQ10k: HighShelfFilter!
    
    init(input: AudioPlayer){
        print("initializing EQ")
        connections.append(input)
        EQ60 = LowShelfFilter(input, cutoffFrequency: 60, gain: 0)
        EQ150 = ParametricEQ(EQ60, centerFreq: 150, q: 1, gain: 0)
        EQ400 = ParametricEQ(EQ150, centerFreq: 400,  q: 1, gain: 0)
        EQ1k = ParametricEQ(EQ400, centerFreq: 1000, q: 1, gain: 0)
        EQ2k4 = ParametricEQ(EQ1k, centerFreq: 2400,  q: 1, gain: 0)
        EQ10k = HighShelfFilter(EQ2k4, cutOffFrequency: 10000, gain: 0)
        avAudioNode = EQ2k4.avAudioNode
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
    
}
