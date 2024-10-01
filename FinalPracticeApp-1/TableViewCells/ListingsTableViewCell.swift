//
//  ListingsTableViewCell.swift
//  FinalPracticeApp-1
//
//  Created by Lynn Thit Nyi Nyi on 1/10/2567 BE.
//

import UIKit
import SDWebImage

class ListingsTableViewCell: UITableViewCell {
    
    var listing: Listing? {
        didSet {
            // Update the listingName label when the listing property is set
            listingName.text = listing?.listingName
            listingFurniture.text = "Room: \(listing?.furniture ?? "")"
            listingPrice.text = "\(listing?.price ?? 0) THB/mo"
            listingStatus.text = "Status: \(listing?.statusActive ?? "not active")"

            // Load the image using the buildImageURL function
            
            if let photoRef = listing?.listingHero?.asset._ref {
                if let imageURL = buildImageURL(from: photoRef) {
                    self.listingImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder")) // Set the image URL
                    print("Image URL: \(imageURL)")
                }
            }
        }
    }

    @IBOutlet weak var listingName: UILabel!
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var listingPrice: UILabel!
    @IBOutlet weak var listingFurniture: UILabel!
    @IBOutlet weak var listingStatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        listingName.text = listing?.listingName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
