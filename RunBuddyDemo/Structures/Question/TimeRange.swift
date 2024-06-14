//
//  TimeRange.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/13/24.
//

import Foundation

struct TimeRange: Comparable, Hashable {
    let title: String
    let minMinutes: Double
    let maxMinutes: Double
    
    static func < (lhs: TimeRange, rhs: TimeRange) -> Bool {
        return lhs.minMinutes < rhs.minMinutes
    }
    
    static func == (lhs: TimeRange, rhs: TimeRange) -> Bool {
        return lhs.minMinutes == rhs.minMinutes && lhs.maxMinutes == rhs.maxMinutes
    }
}
