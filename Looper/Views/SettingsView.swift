//
//  SettingsView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/10/25.
//

import SwiftUI
import AudioKit

struct SettingsView: View {
    @State var EQ60: AUValue = 0;
    @State var EQ150: AUValue = 0;
    @State var EQ400: AUValue = 0;
    @State var EQ1k: AUValue = 0;
    @State var EQ2k4: AUValue = 0;
    @State var EQ10k: AUValue = 0;
    var body: some View {
        VStack{
            // TODO put this at the top
            Text("Settings")
                .font(.title)
                .padding()
            HStack{
                EQSlider(EQ: $EQ60, label: "60Hz", min: -40,max:40)
                    .onChange(of: EQ60, {
                        looper.setEQ60(gain: EQ60)
                    })
                EQSlider(EQ: $EQ150, label: "150Hz",min: -20,max: 20)
                    .onChange(of: EQ150, {
                        looper.setEQ150(gain: EQ150)
                    })
                EQSlider(EQ: $EQ400, label: "400Hz",min: -20,max: 20)
                    .onChange(of: EQ400, {
                        looper.setEQ400(gain: EQ400)
                    })
                EQSlider(EQ: $EQ1k, label: "1kHz",min: -20,max: 20)
                    .onChange(of: EQ1k, {
                        looper.setEQ1k(gain: EQ1k)
                    })
                EQSlider(EQ: $EQ2k4, label: "2k4Hz",min: -20,max: 20)
                    .onChange(of: EQ2k4, {
                        looper.setEQ2k4(gain: EQ2k4)
                    })
                EQSlider(EQ: $EQ10k, label: "10kHz",min: -40,max: 40)
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

#Preview {
    SettingsView()
}
