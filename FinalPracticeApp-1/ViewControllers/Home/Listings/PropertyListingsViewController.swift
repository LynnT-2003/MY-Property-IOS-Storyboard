//
//  PropertyListingsViewController.swift
//  FinalPracticeApp-1
//
//  Created by Lynn Thit Nyi Nyi on 1/10/2567 BE.
//

import UIKit
import Alamofire
import SDWebImage

class PropertyListingsViewController: UIViewController {
    
    @IBOutlet weak var listingsTableView: UITableView!
    var property: Property?
    var listings:[Listing] = []
    
    override func viewDidLoad() {
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        navigationController?.navigationBar.prefersLargeTitles = true
        title = property?.title
        super.viewDidLoad()
        
        if let propertyId = property?._id {
            fetchListingsByPropertyId(byPropertyId: propertyId)
        }
    }
    
    func fetchListingsByPropertyId(byPropertyId propertyId: String) {
        // Construct the query
        let query = "*[property._ref == \"\(propertyId)\"]"
        let urlString = "https://gejbm6fo.api.sanity.io/v2024-08-19/data/query/production?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        // Make the request
        AF.request(urlString).validate().responseDecodable(of: ListingResponse.self) { response in
            switch response.result {
            case .success(let listingResponse):
                print(urlString)
                self.listings = listingResponse.result
                
                // Reload the table view on the main thread
                DispatchQueue.main.async {
                    self.listingsTableView.reloadData()
                }
                
            case .failure(let error):
                print("Error fetching listings: \(error.localizedDescription)")
            }
        }
    }



}

extension PropertyListingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(listings.count)
        return listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listingTableViewCell") as! ListingsTableViewCell
        cell.listing = listings[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
    -> CGFloat {
            return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listingDetailsPage = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "listingDetailsPage") as! ListingDetailsViewController
        listingDetailsPage.listing = listings[indexPath.row]
        listingDetailsPage.property = property
        navigationController?.pushViewController(listingDetailsPage, animated: true)
    }
    
    
}
