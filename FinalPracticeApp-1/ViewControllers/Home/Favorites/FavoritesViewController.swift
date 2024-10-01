import UIKit

class FavoritesViewController: UIViewController {

    var favoriteListings: [Listing] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load favorite listings from UserDefaults
        favoriteListings = loadFavoriteListings()
        
        // Print the favorite listings to check if UserDefaults works
        printFavoriteListings()
    }
    
    func loadFavoriteListings() -> [Listing] {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let favorites = try? JSONDecoder().decode([Listing].self, from: data) {
            return favorites
        }
        return []
    }
    
    func printFavoriteListings() {
        if favoriteListings.isEmpty {
            print("No favorite listings saved.")
        } else {
            for listing in favoriteListings {
                print("Listing Name: \(listing.listingName), Price: \(listing.price), Furniture: \(listing.furniture)")
            }
        }
    }
}
