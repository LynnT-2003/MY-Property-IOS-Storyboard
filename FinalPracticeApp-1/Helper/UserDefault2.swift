//
//  UserDefault2.swift
//  FinalPracticeApp-1
//
//  Created by Lynn Thit Nyi Nyi on 2/10/2567 BE.
//

import Foundation

struct FavoriteListing: Codable {
    let listing: Listing
    let property: Property
}

func saveFavoriteListing(listing: Listing, property: Property) {
    var favorites = loadFavoriteListings()
    
    // Check if the combination already exists
    if !favorites.contains(where: { $0.listing.listingName == listing.listingName }) {
        let favoriteListing = FavoriteListing(listing: listing, property: property)
        favorites.append(favoriteListing)
        saveToUserDefaults(favorites)
    }
}

func removeFavoriteListing(listing: Listing) {
    var favorites = loadFavoriteListings()
    favorites.removeAll { $0.listing.listingName == listing.listingName }
    saveToUserDefaults(favorites)
}

func loadFavoriteListings() -> [FavoriteListing] {
    if let data = UserDefaults.standard.data(forKey: "favorites"),
       let favorites = try? JSONDecoder().decode([FavoriteListing].self, from: data) {
        return favorites
    }
    return []
}

func saveToUserDefaults(_ favorites: [FavoriteListing]) {
    if let data = try? JSONEncoder().encode(favorites) {
        UserDefaults.standard.set(data, forKey: "favorites")
    }
}

func isListingFavorited(_ listing: Listing) -> Bool {
    return loadFavoriteListings().contains { $0.listing.listingName == listing.listingName }
}
