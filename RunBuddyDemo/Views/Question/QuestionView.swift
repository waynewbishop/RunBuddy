//
//  QuestionView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 4/30/24.
//

import SwiftUI
import MapKit
import SwiftData

struct QuestionView: View {

@Binding var searchRegion: MKCoordinateRegion?
@Binding var searchResults: [MKMapItem]

    /*
     note: obtain the placemark information when
     doing the runbuddy analysis. The goal will be to
     pass the details of the search location to
     Gemini in order to get an rough idea of the
     destination elevation.
     */

//persistent storage
@AppStorage("name") private var persistedName = ""
@Query(sort: \Favorite.order) private var favorites: [Favorite]
@Environment(\.modelContext) private var modelContext
    
@State var name: String = ""
@State var selectedDate = setDefaultDate()
@State var selectedOption = "Easy"
@State var terrainOption = "Road"
@State var durationOption = "30 minutes"
@State var nutrition: Bool = false
@State var kit: Bool = false
@State var hydration: Bool = false

//transition variables
@State var isAnimating: Bool = true
@State var showModal: Bool = false
@State var showAlert: Bool = false
@State var showSavedAlert = false
@State var showFavorite: Bool = false


var latitude: String {
    if let region = searchRegion {
        let roundedLatitude = region.center.latitude.rounded(to: 5)
        return String(roundedLatitude)
    } else {
        return ""
    }
}

var longitude: String {
    if let region = searchRegion {
        let roundedLongitude = region.center.longitude.rounded(to: 5)
        return String(roundedLongitude)
    } else {
        return ""
    }
}

    var body: some View {
        ScrollView {
            VStack {
                Spacer()
            }
            VStack {
                HStack {
                    Text("Run Buddy")
                        .font(.title)
                        .bold()
                    Spacer()
                    Button(action: {
                        //deleteAllData(Favorite.self)
                        
                        if saveFavorite() {
                          self.showSavedAlert = true
                        }
                        
                        
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Circle().fill(Color.buttonColor))
                    }
                    .alert(isPresented: $showSavedAlert) {
                        Alert(
                            title: Text("Favorite Saved"),
                            message: Text("\(self.name) has been saved to your favorites."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                
                GroupBox {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search for a destination", text: $name)
                            .autocorrectionDisabled()
                            .autocapitalization(.words)  // Better for place names
                            .onSubmit() {
                                searchMKMapItems()
                            }
                            .onAppear {
                                name = persistedName // Load persisted value on appear
                                if self.name != "" {
                                    self.searchMKMapItems()
                                }
                            }
                            .onChange(of: name) { oldValue, newValue in
                               persistedName = newValue // Save changes to persisted value
                            }
                       Spacer()
                    }
                }
                HStack {
                    Text("Search for a destination like a park or trailhead. You can also pan and zoom the map to a specific location.")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.bottom, 30)
                
                if !favorites.isEmpty {
                    HStack {
                        Text("Favorites")
                            .font(.subheadline.bold())
                            .foregroundColor(.gray)
                        Spacer()
                        
                        Button(action: {
                            // Add your button action here
                            showFavorite = true
                        }) {
                            Text("More")
                                .font(.subheadline.bold())
                        }
                        .sheet(isPresented: $showFavorite) {
                          FavoriteView(showFavorite: $showFavorite)
                        }
                        
                    }
                    GroupBox {
                        HStack {
                            ScrollView(.horizontal) {
                                HStack(spacing: 16) {
                                    ForEach(favorites, id: \.name) { favorite in
                                        Button(action: {
                                            // Action to perform when the button is tapped
                                            print("Tapped \(favorite.name)")
                                            name = favorite.name
                                            self.searchMKMapItems()
                                        }) {
                                            FavoriteImage(name: favorite.name, icon: favorite.systemIcon)
                                        }
                                    }
                                }
                            }
                          Spacer()
                        }
                    }
                }
                
                
                VStack {
                    Spacer()
                }
                .frame(height: 50) // set the desired VStack height
                                
                VStack (alignment: .leading, content: {
                    Text("Run Details")
                        .font(.subheadline.bold())
                        .foregroundColor(.gray)
                    
                    GroupBox {
                        LabeledContent("Duration") {
                            DurationView(selectedOption: $durationOption)
                                .padding(.bottom, 20)
                        }
                        
                        LabeledContent("Type") {
                            RunView(selectedOption: $selectedOption)
                                .padding(.bottom, 20)
                        }
                        
                        LabeledContent("Terrain") {
                            TerrainView(selectedOption: $terrainOption)
                                .padding(.bottom, 20)
                        }
                        
                        LabeledContent("Start Date") {
                            DatePicker("Start Date", selection: $selectedDate, displayedComponents: .date)
                                .labelsHidden()
                                .padding(.bottom, 15)
                        }
                        .onChange(of: selectedDate) { oldValue, newValue in
                           // print(newValue)
                        }
                        
                        Toggle(isOn: $nutrition) {
                            Text("Nutrition Analysis")
                        }
                        .padding(.bottom, 15)
                        
                        Toggle(isOn: $hydration) {
                            Text("Hydration Analysis")
                        }
                        .padding(.bottom, 15)
                        
                        Toggle(isOn: $kit) {
                            Text("Clothing Analysis")
                        }
                        .padding(.bottom, 15)
                    }
                })
                
            }
            .questionSheetStyle()
            Spacer() //top align VStack
            
            VStack {
                
                HStack {
                    Button(action: {
                        
                        //check for a valid date
                        if !selectedDate.isDateAfterToday() {
                            showAlert = true
                        }
                        else {
                            showModal = true
                        }
                    }) {
                        HStack {
                            EllipsisView(isAnimating: $isAnimating)
                                .font(.title)
                            Text("Ask RunBuddy...")
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Invalid Date"),
                              message: Text("Please select a valid date."),
                              dismissButton: .default(Text("OK")))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.blue)
                    .sheet(isPresented: $showModal) {
                        
                        if let region = searchRegion {
                            let location = region.center
                            
                            let question = Question(city: name, location: location, duration: durationOption, selectedDate: selectedDate, intensity: selectedOption, terrainOption: terrainOption, nutrition: nutrition, kit: kit, hydration: hydration)
                            
                            AnalysisView(showModal: $showModal, question: question)
                        }
                        
                    }
                    .padding(5)
                }
                
            }
            
        }
        
    } //end view
    
    //MARK: Helper Functions
    
    //save a favorite location
    private func saveFavorite() -> Bool {
        if (self.name != "") && (searchResults.count > 0) {
            let engine = SearchEngine(searchResults: $searchResults)
            
            //obtain current search context
            let mapItem = searchResults[0]
            let address = mapItem.placemark.locality
            let imageName = engine.imageSystemIconForCategory(mapItem.pointOfInterestCategory)
            
            //persist favorite records
            let newFavorite = Favorite(name: name, address: address, systemIcon: imageName)
            modelContext.insert(newFavorite)
            
            print("there are: \(favorites.count)")
            return true
        }
        else {
            return false
        }
    }
        
    //search for MKMapItems
    private func searchMKMapItems() {
        let engine = SearchEngine(searchResults: $searchResults)
        
        Task {
            do {
                try await engine.search(for: name, in: .washington)
            }
            catch {
                print(error.localizedDescription)
            }
        } //end task
        
    } //end function

    
    
    /// Adjust the current date. The idea being most runners go out in the mornings and not evening.
    /// - Returns: The current or next date
    static func setDefaultDate() -> Date {
       let now = Date()
       let calendar = Calendar.current
       let hour = calendar.component(.hour, from: now)
       
       if hour >= 12 {
           // If it's 12 PM or later, return tomorrow's date
           return calendar.date(byAdding: .day, value: 1, to: now) ?? now
       } else {
           // If it's before 12 PM, return today's date
           return now
       }
    }
    
          
    //removes all favorites
    func deleteAllData<T: PersistentModel>(_ type: T.Type) {
        do {
            try modelContext.delete(model: type)
        } catch {
            print("Error deleting data: \(error)")
        }
    }
    
}


#Preview {
    @State var visibleRegion: MKCoordinateRegion? = .washington
    @State var searchResults: [MKMapItem] = []
    return VStack {
        QuestionView(searchRegion: $visibleRegion, searchResults: $searchResults)
            .modelContainer(for: Favorite.self)
    }
}
