//
//  TerrainTypeView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/7/24.
//

import SwiftUI

struct TerrainView: View {
    
    @Binding var selectedOption: String
    
    let options = ["Road", "Trail"]
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedOption = option
                }) {
                    Text(option)
                }
            }
        } label: {
            HStack {
                Text(selectedOption)
                Image(systemName: "chevron.down")
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    @State var selectedOption: String = "Road"
    return VStack {
        TerrainView(selectedOption: $selectedOption)
    }

}
