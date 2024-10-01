//
//  FirstTabViewController.swift
//  FinalPracticeApp-1
//
//  Created by Lynn Thit Nyi Nyi on 1/10/2567 BE.
//

import UIKit
import Alamofire
import SDWebImage

class FirstTabViewController: UIViewController {
    
    @IBOutlet weak var propertiesCollectionView: UICollectionView!
    
    var properties: [Property] = []

    override func viewDidLoad() {
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Properties"
        super.viewDidLoad()
        fetchProperties()
    }
    
    func fetchProperties() {
        let url = "https://gejbm6fo.api.sanity.io/v2024-08-19/data/query/production?query=*%5B_type+%3D%3D+%22property%22%5D"

        AF.request(url, method: .get).responseDecodable(of: PropertyResponse.self) { response in
            switch response.result {
            case .success(let propertyResponse):
                self.properties = propertyResponse.result
                print("Fetched \(self.properties.count) properties")
                for property in self.properties {
                    print("Property Title: \(property.title), Min Price: \(property.minPrice), Max Price: \(property.maxPrice)")
                }
                
                // Reload the collection view after updating the data
                DispatchQueue.main.async {
                    self.propertiesCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

}

extension FirstTabViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return properties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "propertyCell", for: indexPath) as! PropertyCollectionViewCell
        let property = properties[indexPath.item]
        
        // Example: Assuming you want to use the propertyHero image
        if let photoRef = property.propertyHero.asset._ref {
            if let imageURL = buildImageURL(from: photoRef) {
                cell.propertyImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder")) // Set the image URL
                print("Image URL: \(imageURL)")
            }
        }
        cell.propertyNameLabel.text = property.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listingsPage = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "propertyListingsPage") as! PropertyListingsViewController
        let selectedProperty = properties[indexPath.item]
        listingsPage.property = selectedProperty
        navigationController?.pushViewController(listingsPage, animated: true)
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
