//
//  FavoriteCell.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/16/24.
//

import SwiftUI

//TODO: now we need to add the Favorite structure as a binding..
struct FavoriteCell: View {

//@Binding var favorite: Favorite
    
    var body: some View {
        VStack {
            Image(systemName: "mappin.and.ellipse")  //this image also needs to change to a button..
                .font(.system(size: 35, weight: .regular))
                .foregroundStyle(.white)
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.4))
                        .frame(width: 65, height: 65)
                    )
        }
        .frame(height: 65) // set the desired VStack height
        VStack {
            Text("Bridal Trails")
        }
        
    }
}

#Preview {
    FavoriteCell()
}
