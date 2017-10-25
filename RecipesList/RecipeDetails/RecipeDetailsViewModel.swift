//
//  RecipeDetailsViewModel.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

class RecipeDetailsViewModel {
  private let recipe: Recipe?
  
  var name: String {
    return recipe?.name ?? String()
  }
  
  var description: String {
    return recipe?.description ?? String()
  }
  
  var instructions: String {
    if let instructions = recipe?.instructions {
      return instructions.replaceBrByNewLine()
    }
    return String()
  }
  
  var imagesCount: Int {
    return recipe?.imagesURLs?.count ?? 0
  }
  
  var difficulty: Int {
    return recipe?.difficulty ?? 0
  }
  
  init(recipe: Recipe? = nil) {
    self.recipe = recipe
  }
  
  func imageURL(imageNumber: Int) -> URL? {
    guard let imagesURLs = recipe?.imagesURLs,
      !imagesURLs.isEmpty else {
        return nil
    }
    return imagesURLs[imageNumber]
  }
}

fileprivate extension String {
  func replaceBrByNewLine() -> String {
    return self.replacingOccurrences(of: "<br>",
                                     with: "\n",
                                     options: .regularExpression,
                                     range: nil)
  }
}
