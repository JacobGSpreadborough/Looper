//
//  LoopNavigator.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/30/25.
//

import SwiftUI
import AudioKit
import Waveform

struct LoopNavigator: View {
    @Binding var looper: Looper
    @Binding var sliderUpdating: Bool
    @Binding var currentTime: TimeInterval
    @State private var wasPlaying: Bool = false
    //@State private var
    
    var body: some View {
        VStack{
            Text("Loop")
                .padding()
            HStack{
                // move start of loop back 1 second
                Button(action: {
                    //let stopTime = looper.player.currentTime
                    wasPlaying = looper.isPlaying
                    looper.stop()
                    looper.setLoopStart(startTime: looper.player.editStartTime - 1)
                    //looper.seek(time: stopTime)
                    wasPlaying ? looper.play() : looper.pause()
                }) {
                    Image(systemName: "backward.end")
                }
                .buttonStyle(CustomMainButtonStyle())
                /*
                // move start of loop forward 1 second
                Button(action: {
                    let stopTime = looper.player.currentTime
                    wasPlaying = looper.isPlaying
                    looper.stop()
                    looper.setLoopStart(startTime: looper.player.editStartTime + 1)
                    looper.seek(time: stopTime)
                    wasPlaying ? looper.play() : looper.pause()
                }) {
                    Image(systemName: "forward.end")
                }
                .buttonStyle(CustomSecondaryButtonStyle())
                 */
                // set loop start
                Button(action: {
                    // the time that this takes is proportional to the length of the loop...
                    // using either loop button enables looping
                    let stopTime = looper.player.currentTime
                    wasPlaying = looper.isPlaying
                    let startTime = looper.player.currentTime
                    looper.stop()
                    looper.enableLooping()
                    looper.setLoopStart(startTime: startTime)
                    looper.seek(time: stopTime)
                    wasPlaying ? looper.play() : looper.pause()
                }) {
                    Image(systemName: "arrow.uturn.right")
                }
                .buttonStyle(CustomMainButtonStyle())
                
                Button(action: {
                    let stopTime = looper.player.currentTime
                    wasPlaying = looper.isPlaying
                    looper.stop()
                    looper.isLooping ? looper.disableLooping() : looper.enableLooping()
                    looper.seek(time: stopTime)
                    wasPlaying ? looper.play() : looper.pause()
                    
                }) {
                    Image(systemName: "\(looper.isLooping ? "repeat" : "repeat.badge.xmark")")
                }
                .buttonStyle(CustomMainButtonStyle())
                // set loop end
                Button(action: {
                    // using either loop button enables looping
                    wasPlaying = looper.isPlaying
                    let endTime = looper.player.currentTime
                    looper.stop()
                    looper.enableLooping()
                    looper.setLoopEnd(endTime: endTime)
                    wasPlaying ? looper.play() : looper.pause()
                }) {
                    Image(systemName: "arrow.uturn.right")
                        .rotationEffect(Angle(degrees: 180))
                }
                .buttonStyle(CustomMainButtonStyle())
                /*
                // move end of loop back 1 second
                Button(action: {
                    let stopTime = looper.player.currentTime
                    wasPlaying = looper.isPlaying
                    looper.stop()
                    looper.setLoopEnd(endTime: looper.player.editEndTime - 1)
                    looper.seek(time: stopTime)
                    wasPlaying ? looper.play() : looper.pause()
                }) {
                    Image(systemName: "backward.end")
                }
                .buttonStyle(CustomSecondaryButtonStyle())
                 */
                // move end of loop forward 1 second
                Button(action: {
                    //let stopTime = looper.player.currentTime
                    wasPlaying = looper.isPlaying
                    looper.stop()
                    looper.setLoopEnd(endTime: looper.player.editEndTime + 1)
                    //looper.seek(time: stopTime)
                    wasPlaying ? looper.play() : looper.pause()
                }) {
                    Image(systemName: "forward.end")
                }
                .buttonStyle(CustomMainButtonStyle())
            }
            ZStack{
                Waveform(samples: looper.samples,
                         start: looper.loopStartSample,
                         length: looper.loopLengthSample)
                .foregroundColor(.blue)
                .padding(.vertical)
                .opacity(0.25)
                .frame(width:175)
                Slider(
                    value: $currentTime,
                    in: looper.player.editStartTime...looper.player.editEndTime,
                    label: {},
                    minimumValueLabel: {
                        Text("\(Utils.timeFormatter(time: looper.player.editStartTime))")
                            .monospacedDigit()
                    },
                    maximumValueLabel: {
                        Text("\(Utils.timeFormatter(time: looper.player.editEndTime))")
                            .monospacedDigit()
                    },
                    onEditingChanged: { editing in
                        if(editing) {
                            wasPlaying = looper.isPlaying
                            looper.pause()
                            sliderUpdating = false
                        } else {
                            looper.seek(time:currentTime)
                            wasPlaying ? looper.play() : looper.pause()
                            sliderUpdating = true
                        }
                    }
                )
                //.padding(.vertical)
                .padding(.horizontal)
                .disabled(!looper.isLooping)
            }
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
}

}
