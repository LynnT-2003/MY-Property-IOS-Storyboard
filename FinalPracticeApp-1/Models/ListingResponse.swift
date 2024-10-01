//
//  ListingResponse.swift
//  FinalPracticeApp-1
//
//  Created by Lynn Thit Nyi Nyi on 1/10/2567 BE.
//

import Foundation

struct ListingResponse: Codable {
    let result: [Listing]
}

struct Listing: Codable {
    let _id: String
    let _createdAt: String
    let _updatedAt: String
    let _rev: String
    let listingName: String
    let description: String
    let price: Double
    let minPrice: Double?
    let maxPrice: Double?
    let listingType: String
    let statusActive: String
    let bedroom: Int
    let bathroom: Int
    let furniture: String
    let minimumContractInMonth: Int
    let size: Int
    let floor: Int?
    let listingHero: ImageAsset?
    let listingPhoto: [ImageAsset]?
    let property: PropertyReference

    struct ImageAsset: Codable {
        let asset: AssetReference

        struct AssetReference: Codable {
            let _ref: String?
        }
    }

    struct PropertyReference: Codable {
        let _ref: String
    }
}

