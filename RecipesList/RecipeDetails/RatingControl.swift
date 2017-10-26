//
//  RatingControl.swift
//  RecipesList
//
//  Created by anna on 26.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

fileprivate extension Constants {
  static let ratingItem = "🍗"
  static let ratingAlpha: CGFloat = 0.25
}

class RatingControl: UIStackView {
  func setupControl(maxRating: Int, currentRating: Int) {
    if maxRating <= 0 || currentRating <= 0 {
      print("Max Rating and Current Rating must be positive")
      isHidden = true
      return
    }
    
    for item in 0..<maxRating {
      let label = UILabel()
      label.text = Constants.ratingItem
      if item >= currentRating {
        label.alpha = Constants.ratingAlpha
      }
      addArrangedSubview(label)
    }
  }
}
