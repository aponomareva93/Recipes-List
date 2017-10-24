//
//  RecipesListCellModel.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit
import Kingfisher

class RecipesListCellViewModel {
  private var recipe: Recipe?
  
  var name: String? {
    return recipe?.name
  }
  
  var description: String? {
    return recipe?.description
  }
  
  var imageURL: URL? {
    guard let imagesURLs = recipe?.imagesURLs,
      !imagesURLs.isEmpty else {
        return nil
    }
    return imagesURLs[0]
  }
  
  init(with recipe: Recipe?) {
    self.recipe = recipe
  }
}
