//
//  Colors.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 5/25/24.
//
import SwiftUI

struct Colors {
    static var sheetBackgroundColor: Color {
        let colorScheme = UITraitCollection.current.userInterfaceStyle
        switch colorScheme {
        case .dark:
            return Color(UIColor.systemBackground)
        default:
            return Color(UIColor.systemBackground)
        }
    }
}
