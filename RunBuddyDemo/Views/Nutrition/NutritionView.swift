//
//  NutritionView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 7/1/24.
//

import SwiftUI

struct NutritionView: View {
    
    @ObservedObject var engine = BuddyEngine()
    
    @State var question: Question
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
}

#Preview {
        
    @State var selectedDate = Date().advanceDays(by: 0)
    
    @State var testQuestion = Question(name: "Gig Harbor", location: .gigHarbor, duration: "30 minutes", selectedDate: selectedDate.advanceDays(by: 1), selectedOption: "Easy", terrainOption: "Road", nutrition: false, kit: false, hydration: false)
    
    return VStack {
     NutritionView(question: testQuestion)
    }
    
}
