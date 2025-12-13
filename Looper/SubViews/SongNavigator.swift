//
//  SongNavigator.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/30/25.
//

import SwiftUI
import AudioKit
import Waveform

struct SongNavigator: View {
    @ObservedObject var looper: Looper
    @Binding var currentTime: TimeInterval
    @Binding var sliderUpdating: Bool
    @State private var wasPlaying: Bool = false
    var body: some View {
        // song navigation
        VStack{
            Text("\(looper.fileName.description)")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            ZStack{
                Waveform(samples: looper.samples)
            
                    .foregroundColor(.blue)
                    .padding(.vertical)
                    .opacity(0.25)
                    .frame(width: 175)
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
            //.padding(.vertical)
            
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
    }
}
