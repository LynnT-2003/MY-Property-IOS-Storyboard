//
//  ListingDetailsViewController.swift
//  FinalPracticeApp-1
//
//  Created by Lynn Thit Nyi Nyi on 1/10/2567 BE.
//

import UIKit

class ListingDetailsViewController: UIViewController {
    
    var listing: Listing?

    @IBOutlet weak var listingName: UILabel!
    @IBOutlet weak var listingPRICE: UILabel!
    @IBOutlet weak var listingFurniture: UILabel!
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var listingDescription: UILabel!
    
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
