//
//  SettingsView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/10/25.
//

import SwiftUI
import AudioKit

struct SettingsView: View {
    var body: some View {
        NavigationStack{
            List{
                // TODO add icons to make these look nice
                NavigationLink("Import Song", destination: SongSelectionView())
                NavigationLink("Equalization", destination:
                                EQView())
            }
            .navigationTitle("Settings")
        }
    }
}

struct EQView: View{
    @State var EQ60: AUValue = 0;
    @State var EQ150: AUValue = 0;
    @State var EQ400: AUValue = 0;
    @State var EQ1k: AUValue = 0;
    @State var EQ2k4: AUValue = 0;
    @State var EQ10k: AUValue = 0;
    var body: some View {
        VStack{
            HStack{
                EQSlider(EQ: $EQ60, label: "60Hz", range: -40...40)
                    .onChange(of: EQ60, {
                        looper.setEQ60(gain: EQ60)
                    })
                EQSlider(EQ: $EQ150, label: "150Hz", range: -20...20)
                    .onChange(of: EQ150, {
                        looper.setEQ150(gain: EQ150)
                    })
                EQSlider(EQ: $EQ400, label: "400Hz", range: -20...20)
                    .onChange(of: EQ400, {
                        looper.setEQ400(gain: EQ400)
                    })
                EQSlider(EQ: $EQ1k, label: "1kHz", range: -20...20)
                    .onChange(of: EQ1k, {
                        looper.setEQ1k(gain: EQ1k)
                    })
                EQSlider(EQ: $EQ2k4, label: "2k4Hz", range: -20...20)
                    .onChange(of: EQ2k4, {
                        looper.setEQ2k4(gain: EQ2k4)
                    })
                EQSlider(EQ: $EQ10k, label: "10kHz",range: -40...40)
                    .onChange(of: EQ10k, {
                        looper.setEQ10k(gain: EQ10k)
                    })
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onAppear() {
                // the sliders' states don't save when the view is closed
                EQ60 = looper.EQ60.gain
                EQ150 = looper.EQ150.gain
                EQ400 = looper.EQ400.gain
                EQ1k = looper.EQ1k.gain
                EQ2k4 = looper.EQ2k4.gain
                EQ10k = looper.EQ10k.gain
            }
        }
        .navigationTitle("Equalization")
        .frame(height: 300)
        .padding()
        Button(action: {
            EQ60 = 0
            EQ150 = 0
            EQ400 = 0
            EQ1k = 0
            EQ2k4 = 0
            EQ10k = 0
        }) {
            Text("Reset")
        }
        .frame(height:100,alignment: .bottom)
        .padding()
    }
}

struct SongSelectionView: View {
    var body: some View { 
        List{
            CustomListButton(image: "music.note.square.stack", text: "Apple Music",action: {
                    
                })
            CustomListButton(image: "folder", text: "Documents", action: {
                
            })
            CustomListButton(image: "camera", text: "Videos", action: {
                
            })
            CustomListButton(image: "waveform.mid", text: "Voice memos", action: {
                
            })
        }
    }
}

struct CustomListButton: View{
    var image: String
    var text: String
    var action: () -> Void
    var body: some View {
        Button(
            action: action,
            label: {
                HStack{
                    Image(systemName: image)
                    Text(text)
            }
        })
    }
}

#Preview {
    SettingsView()
}
