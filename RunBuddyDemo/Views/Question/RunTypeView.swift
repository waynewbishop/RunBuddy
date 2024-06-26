//
//  SelectionView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 5/6/24.
//

import SwiftUI

struct RunTypeView: View {
    
    @Binding var selectedOption: String
    
    let options = ["Easy", "Interval", "Tempo", "Threshold", "Fartlek", "Progression", "Hill Repeats", "Race"]
    
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
        RunTypeView(selectedOption: $selectedOption)
    }
}
