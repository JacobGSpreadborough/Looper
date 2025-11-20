//
//  ContentView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 10/24/25.
//

import SwiftUI
import SoundpipeAudioKit
import AudioKit
import Waveform

var looper = Looper()

struct ContentView: View {
    @State private var currentTime: TimeInterval = 0
    @State private var sliderUpdating: Bool = true;
    @State private var volume: Float = 0.5;
    @State private var speed: Float = 1;
    @State private var wasPlaying: Bool = false
    let volumeIcons = ["speaker", "speaker.1", "speaker.2", "speaker.3"]
    var body: some View {
        NavigationView {
            // main stack
            VStack {
                HStack(alignment: .top){
                    // TODO these buttons are bad
                    NavigationLink(destination: HelpView()) {
                        Text("Help")
                            .foregroundStyle(Color(.blue))
                    }
                    .frame(width: 150,alignment: .leading)
                    NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                            .foregroundStyle(Color(.blue))
                    }
                    .frame(width: 150,alignment: .trailing)
                }
                // song navigation
                VStack{
                    Text("\(looper.fileName)")
                        .multilineTextAlignment(.center)
                        .padding()
                    ZStack{
                        Waveform(samples: looper.samples)
                            .foregroundColor(.blue)
                            .opacity(0.25)
                            .frame(width: 180)
                        Slider(
                            value: $currentTime,
                            in: 0...looper.duration,
                            label: {},
                            minimumValueLabel: {
                                Text("\(Utils.timeFormatter(time: currentTime))")
                                    .monospacedDigit()
                            },
                            maximumValueLabel: {
                                Text("\(Utils.timeFormatter(time: looper.duration))")
                                    .monospacedDigit()
                            },
                            // bug? if you hold down the slider while the song is playing,
                            // when you release the slider it will call this twice, first
                            // with editing = false, then with editing = true
                            onEditingChanged: { editing in
                                print("editing:\(editing)")
                                if(editing) {
                                    wasPlaying = looper.isPlaying
                                    sliderUpdating = false
                                    // using the main progress slider turns off looping
                                    looper.stop()
                                    looper.disableLooping()
                                } else {
                                    looper.seek(time:currentTime)
                                    sliderUpdating = true
                                    wasPlaying ? looper.play() : looper.pause()
                                }
                            }
                        )
                    }
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                            if(sliderUpdating){
                                currentTime = looper.player.currentTime
                                //print("ContentView current time: \(currentTime)")
                                //print("Player currentTime:       \(looper.player.currentTime)")
                            }
                        })
                    }
                    .padding(.vertical)
                    
                    HStack{
                        // seek back 5 seconds
                        Button(action: {
                            wasPlaying = looper.isPlaying
                            looper.stop()
                            looper.seek(time: currentTime - 5)
                            // use pause instead of stop to save the current time
                            wasPlaying ? looper.play() : looper.pause()
                        }) {
                            Text("-5s")
                        }
                        .buttonStyle(CustomMainButtonStyle())
                        // seek back 1 second
                        // TODO actually seeks back about 0.97 seconds
                        Button(action: {
                            wasPlaying = looper.isPlaying
                            looper.stop()
                            looper.seek(time: currentTime - 1)
                            // use pause instead of stop to save the current time
                            wasPlaying ? looper.play() : looper.pause()
                        }) {
                            Text("-1s")
                        }
                        .buttonStyle(CustomMainButtonStyle())
                        // play/pause
                        Button(action: {
                            looper.isPlaying ? looper.pause():looper.play()
                        }){
                            Image(systemName: "\(looper.isPlaying ? "pause" : "play")")
                        }
                        .buttonStyle(CustomMainButtonStyle())
                        // seek forward 1 second
                        // TODO actually seeks forward about 0.97 seconds
                        Button(action: {
                            wasPlaying = looper.isPlaying
                            looper.stop()
                            looper.seek(time: currentTime + 1)
                            // use pause instead of stop to save the current time
                            wasPlaying ? looper.play() : looper.pause()
                        }) {
                            Text("+1s")
                        }
                        .buttonStyle(CustomMainButtonStyle())
                        // seek forward 5 seconds
                        Button(action: {
                            wasPlaying = looper.isPlaying
                            looper.stop()
                            looper.seek(time: currentTime + 5)
                            // use pause instead of stop to save the current time
                            wasPlaying ? looper.play() : looper.pause()
                        }) {
                            Text("+5s")
                        }
                        .buttonStyle(CustomMainButtonStyle())
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                // speed and pitch
                // TODO add pitch shift by cents
                VStack {
                    Text("Speed: \((speed * 100), specifier: "%0.0f")%")
                        .monospacedDigit()
                        .fixedSize()
                        .padding()
                    // TODO make this logarithmic
                    Slider(
                        value: $speed,
                        in: 0.25...1.75,
                        label: {}
                    )
                    .onChange(of: speed, {
                        looper.changeSpeed(percent: speed)
                    })
                    //.padding()
                    Stepper(label: {
                        Text("Transpose: \(looper.pitch,specifier: "%0.0f") step\(stringPlural(number: looper.pitch))")
                            .monospacedDigit()
                    },
                            onIncrement: {
                        looper.changePitch(steps: 1)
                    },
                            onDecrement: {
                        looper.changePitch(steps: -1)
                    })
                    //.padding()
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                // loop controls
                VStack{
                    Text("Loop")
                        .padding()
                    HStack{
                        // move start of loop back 1 second
                        Button(action: {
                            let stopTime = looper.player.currentTime
                            wasPlaying = looper.isPlaying
                            looper.stop()
                            looper.setLoopStart(startTime: looper.player.editStartTime - 1)
                            looper.seek(time: stopTime)
                            wasPlaying ? looper.play() : looper.pause()
                        }) {
                            Image(systemName: "backward.end")
                        }
                        .buttonStyle(CustomSecondaryButtonStyle())
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
                        // move end of loop forward 1 second
                        Button(action: {
                            let stopTime = looper.player.currentTime
                            wasPlaying = looper.isPlaying
                            looper.stop()
                            looper.setLoopEnd(endTime: looper.player.editEndTime + 1)
                            looper.seek(time: stopTime)
                            wasPlaying ? looper.play() : looper.pause()
                        }) {
                            Image(systemName: "forward.end")
                        }
                        .buttonStyle(CustomSecondaryButtonStyle())
                    }
                    ZStack{
                        // TODO add waveform over the loop, it takes sample numbers rather that TimeIntervals
                        Waveform(samples: looper.samples,
                                 start: looper.loopStartSample,
                                 length: looper.loopLengthSample)
                        .foregroundColor(.blue)
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
                // volume
                // stack for volume icon and slider
                HStack {
                    // TODO make it perfect
                    Image(systemName: volumeIcons[Int(volume * 3)])
                    Slider(
                        value: $volume,
                        in: 0...0.5
                    )
                    .onChange(of: volume, {
                        looper.player.volume = volume
                    })
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
