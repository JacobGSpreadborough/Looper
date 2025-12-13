//
//  SettingsView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/10/25.
//

import SwiftUI
import AudioKit
import MediaPlayer

struct SettingsView: View {
    @ObservedObject var looper: Looper
    var body: some View {
        NavigationStack{
            List{
                NavigationLink(destination: EQView(looper: looper), label: {
                    HStack{
                        Image(systemName: "slider.vertical.3")
                        Text("Equalization")
                    }
                })
            }
            .navigationTitle("Settings")
        }
    }
}
