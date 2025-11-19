//
//  Utils.swift
//  Looper
//
//  Created by Jacob Spreadborough on 10/24/25.
//
import Foundation

class Utils {
    public static func timeFormatter(time: Double) -> String {
        let minutes = Int(time/60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        // there must be a cleaner way to do this
        let milliseconds = Int((time - Double(Int(time))) * 100)
        return String(format: "%02d:%02d:%02d", minutes,seconds,milliseconds)
    }
}
// 
func stringPlural(number: Float) -> String {
    if(number != 1 && number != -1) {
        return "s"
    }
    return ""
}
