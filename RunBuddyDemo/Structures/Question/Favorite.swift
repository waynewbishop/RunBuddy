//
//  Favorite.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/16/24.
//

import Foundation
import SwiftData
import SwiftUI

//builds the structure for map favorites
struct Favorite: Identifiable {
    var id: ObjectIdentifier
    var name: String
    var icon: Image
    var description: String?
}
