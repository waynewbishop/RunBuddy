//
//  FavoriteView.swift
//  RunBuddyDemo
//
//  Created by Wayne Bishop on 6/21/24.
//

import SwiftUI
import SwiftData

struct FavoriteView: View {
    
    @Binding var showFavorite: Bool
    
    @Query(sort: \Favorite.order) private var favorites: [Favorite]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favorites) { favorite in
                    FavoriteRow(favorite: favorite)
                }
                .onMove(perform: moveFavorites)
                .onDelete(perform: deleteFavorites)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Favorites")
                        .font(.system(size: 25, weight: .bold))
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showFavorite = false
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                }
            }
        }
    }
    
    private func deleteFavorites(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(favorites[index])
        }
    }
    
    private func moveFavorites(from source: IndexSet, to destination: Int) {
        
        print("moveFavorites called: from \(source), to \(destination)")
        
        var updatedFavorites = favorites
        updatedFavorites.move(fromOffsets: source, toOffset: destination)
        
        for (index, favorite) in updatedFavorites.enumerated() {
            favorite.order = index
        }
        
        // Save the changes to the model context
        do {
            try modelContext.save()
        } catch {
            print("Failed to save changes after moving favorites: \(error)")
        }
    }
    
}

struct FavoriteRow: View {
    let favorite: Favorite
    
    var body: some View {

        HStack {
            VStack(alignment: .leading) {
                HStack(spacing: 15) {
                    Image(systemName: favorite.systemIcon)
                        .frame(width: 25, alignment: .center)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(.white)
                        .background(
                            Circle()
                                .fill(Color.buttonColor.opacity(1.0))
                                .frame(width: 35, height: 35)
                        )
                    Text(favorite.name)
                    Spacer()
                }
            }
            .frame(height: 40) // Adjust this value to your desired height
            
        }
        
    }
}

#Preview {

    @State var showFavorite: Bool = true
    
    return VStack {
        FavoriteView(showFavorite: $showFavorite)
            .modelContainer(for: Favorite.self)
    }
    
}
