//
//  RecipeDetailsViewModel.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

fileprivate extension String {
  func replaceBrByNewLine() -> String {
    return self.replacingOccurrences(of: "<br>",
                                     with: "\n",
                                     options: .regularExpression,
                                     range: nil)
  }
}

fileprivate extension Constants {
  static let maxPhotosNumber = 15
}

class RecipeDetailsViewModel {
  private let recipe: Recipe?
  
  var name: String {
    return recipe?.name ?? String()
  }
  
  var description: String {
    guard let description = recipe?.description else {
      return String()
    }
    if description.isEmpty {
      return String()
    }
    return "Description: " + description
  }
  
  var instructions: String {
    if let instructions = recipe?.instructions {
      return instructions.replaceBrByNewLine()
    }
    return String()
  }
  
  var imagesCount: Int {
    guard let count = recipe?.imagesURLs.count else {
      return 0
    }
    if count > Constants.maxPhotosNumber {
      return Constants.maxPhotosNumber
    }
    return count
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
