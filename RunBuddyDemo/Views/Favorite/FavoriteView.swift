//
//  FavoriteView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/21/24.
//

import SwiftUI
import SwiftData

struct FavoriteView: View {

@Query private var favorites: [Favorite]

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FavoriteView()
}
