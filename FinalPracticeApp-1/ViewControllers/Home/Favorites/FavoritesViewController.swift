import UIKit

class FavoritesViewController: UIViewController {

    var favoriteListings: [FavoriteListing] = []
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Favorite Listings"
        
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
    
    func toggleFavorite(for listing: Listing, property: Property) {
        if isListingFavorited(listing) {
            removeFavoriteListing(listing: listing)
            print("\(listing.listingName) removed from favorites.")
        } else {
            saveFavoriteListing(listing: listing, property: property)
            print("\(listing.listingName) added to favorites.")
        }
        
        // Refresh the collection view or UI as necessary
        favoritesCollectionView.reloadData()
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteListings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "favoriteCell", for: indexPath)
            as! FavoriteCollectionViewCell
        
        // Access the listing for the current index path
        let favorite = favoriteListings[indexPath.row]
        let listing = favorite.listing
        
        if let photoRef = listing.listingHero!.asset._ref {
            if let imageURL = buildImageURL(from: photoRef) {
                cell.listingImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder")) // Set the image URL
                print("Image URL: \(imageURL)")
            }
        }
        
        cell.listingName.text = listing.listingName
//        cell.favoriteIcon.image = isListingFavorited(listing) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
//        cell.favoriteIcon.tintColor = .red
        
        // Set the toggle favorite action
        cell.toggleFavoriteAction = { [weak self] in
            self?.toggleFavorite(for: listing, property: favorite.property)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listingDetailsPage = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "listingDetailsPage") as! ListingDetailsViewController
        listingDetailsPage.listing = favoriteListings[indexPath.row].listing
        listingDetailsPage.property = favoriteListings[indexPath.row].property
        navigationController?.pushViewController(listingDetailsPage, animated: true)
    }
    
    func buildImageURL(from partialURL: String) -> URL? {
        
        var cleanedURLString = partialURL.replacingOccurrences(of: "image-", with: "")
        cleanedURLString = cleanedURLString.replacingOccurrences(of: "-jpg", with: ".jpg")
        cleanedURLString = cleanedURLString.replacingOccurrences(of: "-jpeg", with: ".jpeg")
        cleanedURLString = cleanedURLString.replacingOccurrences(of: "-png", with: ".png")
        cleanedURLString = cleanedURLString.replacingOccurrences(of: "-webp", with: ".webp")
        
        let fullURLString = "https://cdn.sanity.io/images/gejbm6fo/production/\(cleanedURLString)"
        print(fullURLString)
        return URL(string: fullURLString)
    }
    
    
}
