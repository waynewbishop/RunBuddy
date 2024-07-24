//
//  Question.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 4/15/24.
//

import Foundation
import SwiftData
import CoreLocation


//builds out the structure for passing question parameters
struct Question {
    let city: String
    let location: CLLocationCoordinate2D
    let duration: String
    let selectedDate: Date
    let intensity: String
    let terrainOption: String
    let nutrition: Bool
    let kit: Bool
    let hydration: Bool
}
