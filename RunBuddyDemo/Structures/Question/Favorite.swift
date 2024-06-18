//
//  Favorite.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/16/24.
//

import Foundation
import SwiftData
import SwiftUI


/// Builds the structure for map favorites
@Model
class Favorite {
    var name: String
    var systemIcon: String
    var desc: String?
    
    init(name: String = "", systemIcon: String = "", desc: String? = nil) {
        self.name = name
        self.systemIcon = systemIcon
        self.desc = desc
    }
}
