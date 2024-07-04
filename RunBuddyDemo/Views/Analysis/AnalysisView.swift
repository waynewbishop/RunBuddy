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
    @State private var refreshTrigger = false
    
    @State private var drivingActionSheet = false
    @State private var showConfirmationDialog = false
    
    var targetDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: question.selectedDate)
    }
    
    
    var body: some View {
        ScrollView {
            VStack {                
                HStack {
                    Spacer()
                }
                .padding()
                HStack {
                    Button(action: {
                        showModal = false
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .padding(6)
                    Spacer()
                    Button(action: {
                               // Show confirmation dialog
                               showConfirmationDialog = true
                           }) {
                               Image(systemName: "ellipsis")
                                   .font(.title2)
                           }
                           .confirmationDialog("Choose an action", isPresented: $showConfirmationDialog) {
                               Button("Refresh Results") {
                                   refreshView()
                               }
                               
                               Button("Driving Directions") {
                                   // Call sheet to invoke driving directions
                               }
                               
                               Button("Share") {
                                   // Call sheet to invoke sharing options
                               }
                               
                               Button("Cancel", role: .cancel) {}
                           }
                }
                .padding(.horizontal)
                          
                VStack {
                    //show weather and supporting analysis
                    ForecastView(location: question.location, targetDate: targetDate, name: question.name, duration: question.duration)
                }
            }
            .id(refreshTrigger)
        }
    }
    
    // toggle the refresh trigger
    private func refreshView() {
        refreshTrigger.toggle()
    }
    
    //get driving directions for the selected location
    private func getDirections() {
        
    }
}



#Preview {
    @State var showModal: Bool  = false
    @State var selectedDate = Date().advanceDays(by: 0)
    
    @State var testQuestion = Question(name: "Gig Harbor", location: .gigHarbor, duration: "30 minutes", selectedDate: selectedDate.advanceDays(by: 1), selectedOption: "Easy", terrainOption: "Road", nutrition: false, kit: false, hydration: false)
    
    return VStack {
        AnalysisView(showModal: $showModal, question: testQuestion)
    }

}
