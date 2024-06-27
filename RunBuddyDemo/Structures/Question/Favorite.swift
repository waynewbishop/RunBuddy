//
//  Favorite.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/16/24.
//

import Foundation
import SwiftData
import SwiftUI


/// Builds the structure for map favorites.
@Model
class Favorite: Identifiable {
    let id: UUID
    @Attribute(.unique) var name: String //provides upsert functionality for matching names
    var address: String?
    var systemIcon: String
    var desc: String?
    var order: Int
    
    init(name: String = "", address: String? = "", systemIcon: String = "", desc: String? = nil) {
        self.id = UUID()
        self.name = name
        self.address = address
        self.systemIcon = systemIcon
        self.desc = desc
        self.order = 0
    }
}
