import UIKit

class FavoritesViewController: UIViewController {

    var favoriteListings: [FavoriteListing] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load favorite listings from UserDefaults
        favoriteListings = loadFavoriteListings()

        // Print the favorite listings to check if UserDefaults works
        printFavoriteListings()
        
        // Extract and print listings and properties
        let listings = extractListings()
        let properties = extractProperties()
        
        print("Extracted Listings: \(listings)")
        print("Extracted Properties: \(properties)")
    }
    
    func printFavoriteListings() {
        if favoriteListings.isEmpty {
            print("No favorite listings saved.")
        } else {
            for favorite in favoriteListings {
                let listing = favorite.listing
                let property = favorite.property
                print("Listing Name: \(listing.listingName), Price: \(listing.price), Furniture: \(listing.furniture)")
                print("For Property Title: \(property.title)")  // Assuming Property has a title property
                // Add more property details as needed
            }
        }
    }
    
    func extractListings() -> [Listing] {
        return favoriteListings.map { $0.listing }
    }
    
    func extractProperties() -> [Property] {
        return favoriteListings.map { $0.property }
    }
}
