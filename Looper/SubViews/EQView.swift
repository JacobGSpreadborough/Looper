//
//  EQView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 12/9/25.
//

import SwiftUI
import AudioKit

struct EQView: View{
    @State var foo: String = ""
    @Binding var looper: Looper
    @State var EQ60: AUValue = 0;
    @State var EQ150: AUValue = 0;
    @State var EQ400: AUValue = 0;
    @State var EQ1k: AUValue = 0;
    @State var EQ2k4: AUValue = 0;
    @State var EQ10k: AUValue = 0;
    @State private var preset: String = "None"
    var EQPresets: [String : [AUValue]] = [ "None": [0,0,0,0,0,0],
                                              "Guitar": [-40,0,8,13,8,-18],
                                            "Bass": [10,13,10,5,-3.5,-16],
                                              "Drums": [40,0,-8,-10,10,30],
                                            "Vocals": [-40,7,16,20,15,17],
                                              "Lowend": [40,20,10,-10,-20,-40],
                                              "Highend": [-40,-20,-10,10,20,40]
    ]
    func setEQ(preset: [AUValue]) {
        EQ60 = preset[0]
        EQ150 = preset[1]
        EQ400 = preset[2]
        EQ1k = preset[3]
        EQ2k4 = preset[4]
        EQ10k = preset[5]
        looper.EQSix.setEQ60(gain: EQ60)
        looper.EQSix.setEQ150(gain: EQ150)
        looper.EQSix.setEQ400(gain: EQ400)
        looper.EQSix.setEQ1k(gain: EQ1k)
        looper.EQSix.setEQ2k4(gain: EQ2k4)
        looper.EQSix.setEQ10k(gain: EQ10k)
    }
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    EQSlider(EQ: $EQ60, label: "60Hz", range: -40...40)
                        .onChange(of: EQ60, {
                            looper.EQSix.setEQ60(gain: EQ60)
                        })
                    EQSlider(EQ: $EQ150, label: "150Hz", range: -20...20)
                        .onChange(of: EQ150, {
                            looper.EQSix.setEQ150(gain: EQ150)
                        })
                    EQSlider(EQ: $EQ400, label: "400Hz", range: -20...20)
                        .onChange(of: EQ400, {
                            looper.EQSix.setEQ400(gain: EQ400)
                        })
                    EQSlider(EQ: $EQ1k, label: "1kHz", range: -20...20)
                        .onChange(of: EQ1k, {
                            looper.EQSix.setEQ1k(gain: EQ1k)
                        })
                    EQSlider(EQ: $EQ2k4, label: "2k4Hz", range: -20...20)
                        .onChange(of: EQ2k4, {
                            looper.EQSix.setEQ2k4(gain: EQ2k4)
                        })
                    EQSlider(EQ: $EQ10k, label: "10kHz",range: -40...40)
                        .onChange(of: EQ10k, {
                            looper.EQSix.setEQ10k(gain: EQ10k)
                        })
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onAppear() {
                    // the sliders' states don't save when the view is closed
                    EQ60 = looper.EQSix.EQ60.gain
                    EQ150 = looper.EQSix.EQ150.gain
                    EQ400 = looper.EQSix.EQ400.gain
                    EQ1k = looper.EQSix.EQ1k.gain
                    EQ2k4 = looper.EQSix.EQ2k4.gain
                    EQ10k = looper.EQSix.EQ10k.gain
                }
                Picker("Preset: \(preset)", selection: $preset){
                    ForEach(Array(EQPresets.keys), id: \.self) { key in
                        Text(key)
                    }
                }
                .onChange(of: preset, {
                    setEQ(preset: EQPresets[preset]!)
                })
                Button("Reset"){
                    preset = "None"
                }
                //.frame(height:100,alignment: .bottom)
                .padding()
            }
            .navigationTitle("Equalization")
            .frame(height: 300)
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var looper = Looper(song: Song.demoSong)
    EQView(looper: $looper)
}
