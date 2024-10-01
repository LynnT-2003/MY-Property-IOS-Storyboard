//
//  ListingDetailsViewController.swift
//  FinalPracticeApp-1
//
//  Created by Lynn Thit Nyi Nyi on 1/10/2567 BE.
//

import UIKit
import MapKit

class ListingDetailsViewController: UIViewController {
    
    var listing: Listing?
    var property: Property?

    @IBOutlet weak var listingName: UILabel!
    @IBOutlet weak var listingPRICE: UILabel!
    @IBOutlet weak var listingFurniture: UILabel!
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var listingDescription: UILabel!
    @IBOutlet weak var listingMapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listingName.text = listing?.listingName
        listingDescription.text = listing?.description
        listingPRICE.text = "Rent: \(Int(listing?.price.rounded() ?? 0)) THB / mo"
        listingFurniture.text = "Room: \(listing?.furniture ?? "")"
        
        
        if let photoRef = listing?.listingHero?.asset._ref {
            if let imageURL = buildImageURL(from: photoRef) {
                self.listingImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder")) // Set the image URL
                print("Image URL: \(imageURL)")
            }
        }
        
        // Add map marker
        if let lat = property?.latitude, let lng = property?.longitude {
            addMarker(at: CLLocationCoordinate2D(latitude: lat, longitude: lng))
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
    
    // Function to add a marker (annotation) to the map
    func addMarker(at coordinate: CLLocationCoordinate2D) {
        // Create a marker (annotation)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = listing?.listingName
        annotation.subtitle = listing?.description
        
        // Add the marker to the map
        listingMapView.addAnnotation(annotation)
        
        // Center the map on the marker's location and set zoom level
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        listingMapView.setRegion(region, animated: true)
    }

}
