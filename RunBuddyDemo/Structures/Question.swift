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
    let name: String
    let location: CLLocationCoordinate2D
    let distance: String
    let selectedDate: Date
    let targetTime: Date
    let selectedOption: String
    let nutrition: Bool
    let kit: Bool
    let hydration: Bool
}
