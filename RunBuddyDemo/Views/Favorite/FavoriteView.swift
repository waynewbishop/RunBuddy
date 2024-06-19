//
//  FavoriteView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/16/24.
//

import SwiftUI

struct FavoriteView: View {
    
var name: String
var icon: String
    
    var body: some View {
        VStack {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 25, weight: .regular))
                    .foregroundStyle(.white)
                    .background(
                        Circle()
                            .fill(getRandomColor().opacity(0.4))
                            .frame(width: 45, height: 45)
                    )
            }
            .frame(height: 45)
            VStack {
                Text(name)
                    .font(.caption2)
            }
        }
    }
        
    //obtains a random color
    func getRandomColor() -> Color {
        let colors: [Color] = [.green, .blue, .yellow, .orange, .red, .purple, .gray]
        let randomIndex = Int.random(in: 0..<colors.count)
        return colors[randomIndex]
    }
        
}

#Preview {
    
    @State var name = "Perrigo Park"
    let systemIcon = "mappin.and.ellipse"
    
    return VStack {
        FavoriteView(name: name, icon: systemIcon)
    }
}
