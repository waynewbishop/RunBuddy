//
//  FavoriteView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/16/24.
//

import SwiftUI

struct FavoriteView: View {
    
@State var name: String
@State var displayName: String = ""
@State var icon: String
    
    var body: some View {
        VStack {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(.white)
                    .background(
                        Circle()
                            .fill(Color.buttonColor.opacity(1.0))
                            .frame(width: 35, height: 35)
                    )
            }
            .frame(height: 45)
            VStack {
                Text(name.truncated())
                    .font(.caption2)
                    .foregroundStyle(Color.black)
            }
            .onAppear{
                displayName = name
            }
        }
    }
                
}

#Preview {
    
    @State var name = "Zion National Park"
    let systemIcon = "mappin.and.ellipse"
    
    return VStack {
        FavoriteView(name: name, displayName: name, icon: systemIcon)
    }
}
