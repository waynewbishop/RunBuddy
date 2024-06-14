//
//  TerrainTypeView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/7/24.
//

import SwiftUI

struct DurationView: View {
    
    @Binding var selectedOption: String

    @State var sortedTimeRanges = [TimeRange]()
    
    var body: some View {
        Menu {
            ForEach(sortedTimeRanges, id: \.self) { timeRange in
                Button(action: {
                    selectedOption = timeRange.title
                }) {
                    Text(timeRange.title)
                }
            }
        } label: {
            HStack {
                Text(selectedOption)
                Image(systemName: "chevron.down")
                    .foregroundColor(.secondary)
            }
        }
        .onAppear(perform: {
            buildTimeRanges()
        })
    }
    
    //build the comparable time ranges
    private func buildTimeRanges() {
        
        //create custom time range elements
        let timeRanges: [TimeRange] = [
            TimeRange(title: "30 minutes", minMinutes: 0, maxMinutes: 30),
            TimeRange(title: "30 - 60 minutes", minMinutes: 30, maxMinutes: 60),
            TimeRange(title: "60 - 90 minutes", minMinutes: 60, maxMinutes: 90),
            TimeRange(title: "90 - 120 minutes", minMinutes: 90, maxMinutes: 120),
            TimeRange(title: "2.0 - 2.5 hours", minMinutes: 120, maxMinutes: 150),
            TimeRange(title: "3.0 - 3.5 hours", minMinutes: 180, maxMinutes: 210),
            TimeRange(title: "3.5 - 4 hours", minMinutes: 210, maxMinutes: 240),
            TimeRange(title: "4.0 - 4.5 hours", minMinutes: 240, maxMinutes: 270),
            TimeRange(title: "5.0 - 5.5 hours", minMinutes: 300, maxMinutes: 330),
            TimeRange(title: "5.5 - 6 hours", minMinutes: 330, maxMinutes: 360)
        ]
        
       //sort the series
       sortedTimeRanges = timeRanges.sorted()
        
    }
    
}

#Preview {
    @State var durationOption: String = "30 minutes"
    
    return VStack {
        DurationView(selectedOption: $durationOption)
    }

}
