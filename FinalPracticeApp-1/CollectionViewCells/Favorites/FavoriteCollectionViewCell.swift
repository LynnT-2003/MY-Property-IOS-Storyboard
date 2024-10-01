//
//  FavoriteCollectionViewCell.swift
//  FinalPracticeApp-1
//
//  Created by Lynn Thit Nyi Nyi on 2/10/2567 BE.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var listingName: UILabel!
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var favoriteIcon: UIImageView!
    
    var toggleFavoriteAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add a tap gesture recognizer to the heart icon
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(heartTapped))
        favoriteIcon.isUserInteractionEnabled = true
        favoriteIcon.addGestureRecognizer(tapGesture)
    }

    @objc private func heartTapped() {
        toggleFavoriteAction?()
    }
    
    
}
