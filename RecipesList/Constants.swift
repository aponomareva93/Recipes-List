//
//  Constants.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

struct Constants {
  static let recipeNameColor = UIColor.brown
  
  enum SortTypes: String {
    case dateSort = "By Date"
    case alphabeticallySort = "Alphabetically"
  }
  static let sortTypesArray = [
    SortTypes.dateSort,
    SortTypes.alphabeticallySort
  ]
}
