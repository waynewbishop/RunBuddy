//
//  FavoriteCell.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/16/24.
//

import SwiftUI


struct FavoriteView: View {
    
@Binding var selectedName: String
var systemIcon: String
    
    var body: some View {
        VStack {
            Button(action: {
                // Add your action code here, e.g., toggle favorite state
                print("now loading a favorite location...")
            }) {
                Image(systemName: systemIcon)
                    .font(.system(size: 35, weight: .regular))
                    .foregroundStyle(.white)
                    .background(
                        Circle()
                            .fill(getRandomColor().opacity(0.4))
                            .frame(width: 65, height: 65)
                    )
            }
        }
        .frame(height: 65) // set the desired VStack height
        VStack {
            Text(selectedName)
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
        FavoriteView(selectedName: $name, systemIcon: systemIcon)
    }
}
