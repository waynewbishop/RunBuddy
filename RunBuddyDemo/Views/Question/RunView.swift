//
//  SelectionView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 5/6/24.
//

import SwiftUI

struct RunView: View {
    
    @Binding var selectedOption: String
    
    let options = ["Easy", "Tempo", "Threshold", "Interval", "Fartlek", "Progression", "Hill Repeats", "Race"]
    
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
 @State var selectedOption: String = "Easy"
    return VStack {
        RunView(selectedOption: $selectedOption)
    }
}
