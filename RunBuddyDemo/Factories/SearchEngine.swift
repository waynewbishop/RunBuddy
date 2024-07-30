//
//  SearchEngine.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 5/1/24.
//

import Foundation
import MapKit
import SwiftUI

struct SearchEngine {

    @Binding var searchResults: [MKMapItem]
    
    func search(for query: String, in searchRegion: MKCoordinateRegion) async throws -> () {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        
        //searchable region
        request.region = searchRegion
        
        let search = MKLocalSearch(request: request)
        
        do {
            let response = try await search.start()
            
            //update binding property on main thread
            DispatchQueue.main.async {
                self.searchResults = response.mapItems
                print("\(searchResults.count) search results..")
            }
          } catch {
            //throw a general error
            print("Error during search..")
            throw error
          }
        
    } //end function
    
    //associates a map point of interest with a system icon
    func imageSystemIconForCategory(_ category: MKPointOfInterestCategory?) -> String {
        
        print(category!)
        
        switch category {
        case .airport:
            return "airplane"
        case .amusementPark:
            return "mappin"
        case .aquarium:
            return "fish"
        case .atm:
            return "atm"
        case .bakery:
            return "bread.slice"
        case .bank:
            return "building.columns"
        case .beach:
            return "beach.umbrella"
        case .brewery:
            return "mug"
        case .cafe:
            return "cup.and.saucer"
        case .campground:
            return "tent"
        case .carRental:
            return "car"
        case .evCharger:
            return "bolt.car"
        case .fireStation:
            return "truck.firefighter"
        case .fitnessCenter:
            return "figure.walk"
        case .gasStation:
            return "gas.pump"
        case .hospital:
            return "hospital"
        case .hotel:
            return "bed.double"
        case .laundry:
            return "washer"
        case .library:
            return "book"
        case .marina:
            return "ship.ferry"
        case .movieTheater:
            return "film"
        case .museum:
            return "paintpalette"
        case .nationalPark:
            return "photo.on.rectangle.angled"
        case .park:
            return "figure.run"
        case .parking:
            return "parkingsign"
        case .pharmacy:
            return "pill"
        case .police:
            return "badge.sheriff"
        case .postOffice:
            return "envelope"
        case .restaurant:
            return "fork.knife"
        case .restroom:
            return "toilet"
        case .school:
            return "building"
        case .stadium:
            return "building"
        case .university:
            return "graduationcap"
        case .winery:
            return "winebottle"
        case .zoo:
            return "paw"
        default:
            return "mappin"
        }
    }
    
}


