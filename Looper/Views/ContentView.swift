//
//  ContentView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 10/24/25.
//

import SwiftUI

let fileName:String = "demo audio"

struct ContentView: View {
    @State var looper = Looper(url: Bundle.main.url(forResource: fileName, withExtension: "mp3")!)
    var body: some View {
        TabView{
            Tab("Looper", systemImage: "repeat") {
                LooperView(looper: $looper)
                    .padding()
            }
            Tab("Library", systemImage: "books.vertical.fill"){
                LibraryView(looper: $looper)
                    .padding()
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView(looper: $looper)
                    .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
