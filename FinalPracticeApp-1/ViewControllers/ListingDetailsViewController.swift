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
    
    let destinationLat = 13.611696106739041
    let destinationLng = 100.83792186056604
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listingName.text = listing?.listingName
        listingDescription.text = listing?.description
        listingPRICE.text = "Rent: \(Int(listing?.price.rounded() ?? 0)) THB / mo"
        listingFurniture.text = "Room: \(listing?.furniture ?? "")"
        
        listingMapView.delegate = self
        
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
        annotation.title = property?.title
//        annotation.subtitle = listing
        
        if let propertyLat = property?.latitude, let propertyLng = property?.longitude {
            let propertyCoordinate = CLLocationCoordinate2D(latitude: propertyLat, longitude: propertyLng)
            let destinationCoordinate = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLng)
            
            calculateWalkingDistanceAndDrawRoute(from: propertyCoordinate, to: destinationCoordinate) { distanceInKilometers in
                // Show an alert with the property description and walking distance
                annotation.subtitle = "\(String(format: "%.2f", distanceInKilometers)) km from ABAC"
            }
        }
        
        // Add the marker to the map
        listingMapView.addAnnotation(annotation)
        
        // Center the map on the marker's location and set zoom level
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        listingMapView.setRegion(region, animated: true)
    }

}

extension ListingDetailsViewController: MKMapViewDelegate {
    
    // Delegate method to customize the annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "listingAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            // Create the info button and add it to the callout
            let infoButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = infoButton
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    // Handle the tap on the info button
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            // Calculate walking distance and draw route
            if let propertyLat = property?.latitude, let propertyLng = property?.longitude {
                let propertyCoordinate = CLLocationCoordinate2D(latitude: propertyLat, longitude: propertyLng)
                let destinationCoordinate = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLng)
                
                calculateWalkingDistanceAndDrawRoute(from: propertyCoordinate, to: destinationCoordinate) { distanceInKilometers in
                    // Show an alert with the property description and walking distance
                    let alertMessage = "Walking distance: \(String(format: "%.2f", distanceInKilometers)) km"
                    let alert = UIAlertController(title: "Property Information", message: alertMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Function to calculate walking distance, draw route, and execute a completion handler with the result
    func calculateWalkingDistanceAndDrawRoute(from originCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D, completion: @escaping (Double) -> Void) {
        let sourcePlacemark = MKPlacemark(coordinate: originCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .walking  // Specify walking directions
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Error calculating directions: \(error.localizedDescription)")
                completion(0) // Return 0 in case of an error
                return
            }

            if let route = response?.routes.first {
                let distanceInMeters = route.distance
                let distanceInKilometers = distanceInMeters / 1000.0
                
                // Draw the route on the map
                self.listingMapView.addOverlay(route.polyline)
               
    
                // Adjust the map region to fit the route
                self.listingMapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
                
                completion(distanceInKilometers)
            } else {
                completion(0) // Return 0 if no route is found
            }
        }
    }
    
    // Render the route on the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 3.0
            return renderer
        }
        return MKOverlayRenderer()
    }
}
