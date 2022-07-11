//
//  CustomCollectionViewCell.swift
//  The Movie Database
//
//  Created by Beavean on 11.07.2022.
//

import UIKit
import SDWebImage

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func layoutSubviews() {
        cellImageView.layer.cornerRadius = cellImageView.bounds.width / 2
    }
    
}
