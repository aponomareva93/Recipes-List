//
//  photosCollectionVewCell.swift
//  RecipesList
//
//  Created by anna on 25.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit
import Kingfisher

class PhotosCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private weak var photoImageView: UIImageView!
  
  func setup(imageURL: URL) {
    photoImageView.kf.setImage(with: imageURL, placeholder: Constants.placeholderImage)
  }
}
