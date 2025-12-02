//
//  LooperApp.swift
//  Looper
//
//  Created by Jacob Spreadborough on 10/24/25.
//

import SwiftUI
import SwiftData

@main
struct LooperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Song.self)
        }
    }
}
