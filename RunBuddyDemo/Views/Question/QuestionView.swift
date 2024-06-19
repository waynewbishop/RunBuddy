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
@Query private var favorites: [Favorite]
@Environment(\.modelContext) private var modelContext
    
@State var name: String = ""
@State var selectedDate = Date()
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
                        self.saveFavorite()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Circle().fill(Color.yellow))
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
                .padding(.bottom, 20)
                
                HStack {
                    Text("Favorites")
                        .font(.subheadline.bold())
                        .foregroundColor(.gray)
                    Spacer()
                }
                GroupBox {
                    HStack {
                        ScrollView(.horizontal) {
                            HStack(spacing: 16) {
                                ForEach(favorites, id: \.name) { favorite in
                                    FavoriteView(name: favorite.name, icon: favorite.systemIcon)
                                }
                            }
                        }
                      Spacer()
                    }
                }
                
                
                VStack {
                    Divider()
                        .background(.gray)
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
                            print(newValue)
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
                            
                            let question = Question(name: name, location: location, duration: durationOption, selectedDate: selectedDate, selectedOption: selectedOption, terrainOption: terrainOption, nutrition: nutrition, kit: kit, hydration: hydration)
                            
                            AnalysisView(showModal: $showModal, question: question)
                        }
                        
                    }
                    .padding(5)
                }
                
            }
            
        }
        
    } //end view
    
    //save a favorite location
    private func saveFavorite() {
        
        if (self.name != "") && (searchResults.count > 0) {
            let engine = SearchEngine(searchResults: $searchResults)
            
            //obtain the current search context
            let mapItem = searchResults[0]
            let imageName = engine.imageSystemIconForCategory(mapItem.pointOfInterestCategory)
            
            //create a persist record using context
            let newFavorite = Favorite(name: name, systemIcon: imageName)
            modelContext.insert(newFavorite)
            
            print("icon name: \(imageName)")
            
            print("there are: \(favorites.count)")
                            
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
    
}


#Preview {
    @State var visibleRegion: MKCoordinateRegion? = .washington
    @State var searchResults: [MKMapItem] = []
    return VStack {
        QuestionView(searchRegion: $visibleRegion, searchResults: $searchResults)
    }
}
