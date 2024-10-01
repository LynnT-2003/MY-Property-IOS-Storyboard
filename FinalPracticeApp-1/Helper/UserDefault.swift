//
//  UserDefault.swift
//  FinalPracticeApp-1
//
//  Created by Lynn Thit Nyi Nyi on 2/10/2567 BE.
//

import Foundation

func saveFavoriteListing(_ listing: Listing) {
    var favorites = loadFavoriteListings()
    if !favorites.contains(where: { $0.listingName == listing.listingName }) {
        favorites.append(listing)
        saveToUserDefaults(favorites)
    }
}

func removeFavoriteListing(_ listing: Listing) {
    var favorites = loadFavoriteListings()
    favorites.removeAll { $0.listingName == listing.listingName }
    saveToUserDefaults(favorites)
}

func loadFavoriteListings() -> [Listing] {
    if let data = UserDefaults.standard.data(forKey: "favorites"),
       let favorites = try? JSONDecoder().decode([Listing].self, from: data) {
        return favorites
    }
    return []
}

func saveToUserDefaults(_ favorites: [Listing]) {
    if let data = try? JSONEncoder().encode(favorites) {
        UserDefaults.standard.set(data, forKey: "favorites")
    }
}

func isListingFavorited(_ listing: Listing) -> Bool {
    return loadFavoriteListings().contains { $0.listingName == listing.listingName }
}
