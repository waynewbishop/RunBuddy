//
//  Color.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/20/24.
//

import Foundation
import SwiftUI


extension Color {
    //sets the default color for all app buttons
    static var buttonColor: Color {
        Color.blue
            .opacity(0.5)
    }
    
    static func random() -> Color {
        let colors: [Color] = [.green, .blue, .orange, .gray]
        return colors.randomElement() ?? .black
    }
}
