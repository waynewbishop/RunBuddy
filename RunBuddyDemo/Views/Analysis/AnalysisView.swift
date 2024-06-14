//
//  AnalysisView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 5/24/24.
//

import SwiftUI
import CoreLocation


struct AnalysisView: View {
    @Binding var showModal: Bool
    
    @State var question: Question
    @State var isAnimating: Bool = true
    
    
    var targetDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: question.selectedDate)
    }
    
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    
                }
                .frame(height: 15)
                HStack {
                    EllipsisView(isAnimating: $isAnimating)
                    Spacer()
                    Button(action: {
                        showModal = false
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                }
                .padding(.horizontal)
         
                 
                VStack {
                    //show weather and supporting analysis
                    ForecastView(location: question.location, targetDate: targetDate, name: question.name, distance: question.distance)
                }
            }
        }
    }
}



#Preview {
    @State var showModal: Bool  = false
    @State var selectedDate = Date().advanceDays(by: 0)
    
    @State var testQuestion = Question(name: "Ballard Locks", location: .gigHarbor, distance: "3.1", selectedDate: selectedDate.advanceDays(by: 5), selectedOption: "Easy", terrainOption: "Road", nutrition: false, kit: false, hydration: false)
    
    return VStack {
        AnalysisView(showModal: $showModal, question: testQuestion)
    }

}
