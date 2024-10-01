//
//  PropertyResponse.swift
//  FinalPracticeApp-1
//
//  Created by Lynn Thit Nyi Nyi on 1/10/2567 BE.
//

import Foundation

struct PropertyResponse: Codable {
    let result: [Property]
}

struct Property: Codable {
    let _id: String
    let _createdAt: String
    let _updatedAt: String
    let _rev: String
    let title: String
    let slug: Slug
    let description: String
    let minPrice: Double
    let maxPrice: Double
    let latitude: Double
    let longitude: Double
    let propertyHero: ImageAsset
    let photos: [ImageAsset]?
    let facilities: [Facility]?

    struct Slug: Codable {
        let current: String
    }

    struct ImageAsset: Codable {
        let asset: AssetReference

        struct AssetReference: Codable {
            let _ref: String?
        }
    }

    struct Facility: Codable {
        let facilityType: String
        let description: String?
        let photos: [ImageAsset]?
    }
}
