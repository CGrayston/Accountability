//
//  Color+Additions.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/7/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

extension Color {
    public static func greenRedProgress(progress: Double) -> Color {
        let percent = Int(progress * 100)
        let modVal = CGFloat((Double(percent).truncatingRemainder(dividingBy: 50) / 50) * 255)
        
        switch percent {
        case 0:
            return Color.red
        case 1..<50:
            return Color(red: 1.0, green: Double(modVal/255), blue: 0)
        case 50:
            return Color.yellow
        case 51..<100:
            return Color(red: Double(255 - modVal)/255, green: 0.9, blue: 0)
        case 100:
            return Color.green
        default:
            return Color(red: 0, green: 1.0, blue: 0)
        }
    }
}

// MARK: - Custom colors

extension Color {
    static let barBackground = Color("barBackground")
    static let background = Color("background")
    static let gold = Color("gold")
}
