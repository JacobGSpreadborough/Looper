//
//  SettingsView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/10/25.
//

import SwiftUI
import AudioKit

struct SettingsView: View {
    @State private var EQ60: AUValue = 0;
    @State private var EQ150: AUValue = 0;
    @State private var EQ400: AUValue = 0;
    @State private var EQ1k: AUValue = 0;
    @State private var EQ2k4: AUValue = 0;
    @State private var EQ15k: AUValue = 0;
    var body: some View {
        VStack{
            // TODO put this at the top
            Text("Settings")
                .font(.title)
                .padding()
            HStack{
                VStack{
                    Text("\(EQ60, specifier: "%0.1f")dB")
                        .fixedSize()
                        .monospacedDigit()
                        .frame(height:150,alignment:.top)
                    Slider(
                        value: $EQ60,
                        in: -20...20
                    )
                    .frame(width:300)
                    .fixedSize()
                    .rotationEffect(Angle(degrees: -90))
                    .onChange(of: EQ60, {
                        looper.setEQ60(gain: EQ60)
                    })
                    Text("60Hz")
                        .frame(height:150,alignment:.bottom)
                }
                .frame(width: 52)
                VStack{
                    Text("\(EQ150, specifier: "%0.1f")dB")
                        .fixedSize()
                        .monospacedDigit()
                        .frame(height:150,alignment:.top)
                    Slider(
                        value: $EQ150,
                        in: -20...20
                    )
                    .frame(width:300)
                    .fixedSize()
                    .rotationEffect(Angle(degrees: -90))
                    .onChange(of: EQ150, {
                        looper.setEQ150(gain: EQ150)
                    })
                    Text("150Hz")
                        .frame(height:150,alignment:.bottom)
                }
                .frame(width: 52)
                VStack{
                    Text("\(EQ400, specifier: "%0.1f")dB")
                        .fixedSize()
                        .monospacedDigit()
                        .frame(height:150,alignment:.top)
                    Slider(
                        value: $EQ400,
                        in: -20...20
                    )
                    .frame(width:300)
                    .fixedSize()
                    .rotationEffect(Angle(degrees: -90))
                    .onChange(of: EQ400, {
                        looper.setEQ400(gain: EQ400)
                    })
                    Text("400Hz")
                        .frame(height:150,alignment:.bottom)
                }
                .frame(width: 52)
                VStack{
                    Text("\(EQ1k, specifier: "%0.1f")dB")
                        .fixedSize()
                        .monospacedDigit()
                        .frame(height:150,alignment:.top)
                    Slider(
                        value: $EQ1k,
                        in: -20...20
                    )
                    .frame(width:300)
                    .fixedSize()
                    .rotationEffect(Angle(degrees: -90))
                    .onChange(of: EQ1k, {
                        looper.setEQ1k(gain: EQ1k)
                    })
                    Text("1kHz")
                        .frame(height:150,alignment:.bottom)
                }
                .frame(width: 52)
                VStack{
                    Text("\(EQ2k4, specifier: "%0.1f")dB")
                        .fixedSize()
                        .monospacedDigit()
                        .frame(height:150,alignment:.top)
                    Slider(
                        value: $EQ2k4,
                        in: -20...20
                    )
                    .frame(width:300)
                    .fixedSize()
                    .rotationEffect(Angle(degrees: -90))
                    .onChange(of: EQ2k4, {
                        looper.setEQ2k4(gain: EQ2k4)
                    })
                    Text("2k4Hz")
                        .frame(height:150,alignment:.bottom)
                }
                .frame(width: 52)
                VStack{
                    Text("\(EQ15k, specifier: "%0.1f")dB")
                        .fixedSize()
                        .monospacedDigit()
                        .frame(height:150,alignment:.top)
                    Slider(
                        value: $EQ15k,
                        in: -20...20
                    )
                    .frame(width:300)
                    .fixedSize()
                    .rotationEffect(Angle(degrees: -90))
                    .onChange(of: EQ15k, {
                        looper.setEQ15k(gain: EQ15k)
                    })
                    Text("15kHz")
                        .frame(height:150,alignment:.bottom)
                }
                .frame(width: 52)
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
                EQ15k = looper.EQ15k.gain
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
            EQ15k = 0
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
