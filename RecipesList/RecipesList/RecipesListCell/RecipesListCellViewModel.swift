//
//  RecipesListCellModel.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class RecipesListCellViewModel {
  private var recipe: Recipe
  
  var name: String? {
    return recipe.name
  }
  
  var description: String? {
    return recipe.description
  }
  
  var imageURL: URL? {
    return recipe.imagesURLs.first as? URL
  }
  
  init(with recipe: Recipe) {
    self.recipe = recipe
  }
}
