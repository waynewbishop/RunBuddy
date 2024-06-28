//
//  MapView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 4/15/24.
//

import SwiftUI
import MapKit


extension MKCoordinateRegion {

    static let washington = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 44.95095247964279, longitude: -120.72892421454331), span: MKCoordinateSpan(latitudeDelta: 13.248434414740949, longitudeDelta: 8.63519284897437))
}


struct MapView: View {
    
    @State private var position: MapCameraPosition = .region(.washington)
    @State var searchRegion: MKCoordinateRegion?
    @State private var isSheetPresented: Bool = true
    @State var searchResults: [MKMapItem] = []
    
    var body: some View {
        Map(position: $position) {
            /*
             note: with this model I don't need markers
             I can just zoom in on the specified region
             by the users selection or by using the search
             interface.
             */
        }
        .ignoresSafeArea()
        .mapStyle(.standard(elevation: .realistic))
        .sheet(isPresented: $isSheetPresented) {
            QuestionView(searchRegion: $searchRegion, searchResults: $searchResults)
                .background(Colors.sheetBackgroundColor)
                .modelContainer(for: Favorite.self)
        }
        .onMapCameraChange { context in
            searchRegion = context.region
            //print(searchRegion.debugDescription)
        }
        .onChange(of: searchResults) {
            
            let mapItem = searchResults[0]
            
            let coordinate = mapItem.placemark.coordinate
            let zoomLevel: Double = 0.033
                       
            withAnimation(.easeInOut(duration: 5.00)) { // Adjust animation duration
                position = .region(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel)))
            }
            
        }
    }
}

#Preview {
    MapView()
}
