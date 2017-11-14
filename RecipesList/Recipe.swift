//
//  Recipe.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

fileprivate extension Constants {
  static let invalidJSONDataError = (domain: "recipe init domain",
                                     code: 1,
                                     userInfo: [NSLocalizedDescriptionKey:
                                      "Impossible to fetch recipe parameters from JSON data"])
}

private struct Keys {
  static let name = "name"
  static let images = "images"
  static let lastUpdated = "lastUpdated"
  static let instructions = "instructions"
  static let difficulty = "difficulty"
  static let description = "description"
}

struct Recipe: JSONMappable {
  let name: String
  let imagesURLs: [URL?]
  let lastUpdated: Int
  let instructions: String
  var description: String?
  let difficulty: Int
  
  init(fromJSON json: JSON?) throws {
    guard let name = json?[Keys.name] as? String,
    let imagesURLsNames = json?[Keys.images] as? [String],
    let lastUpdated = json?[Keys.lastUpdated] as? Int,
    let instructions = json?[Keys.instructions] as? String,
    let difficulty = json?[Keys.difficulty] as? Int else {
      let error = NSError(domain: Constants.invalidJSONDataError.domain,
                          code: Constants.invalidJSONDataError.code,
                          userInfo: Constants.invalidJSONDataError.userInfo)
      throw error
    }
    
    self.name = name
    self.lastUpdated = lastUpdated
    self.instructions = instructions
    self.difficulty = difficulty
    
    var urls = [URL?]()
    for imageURLName in imagesURLsNames {
      let url = URL(string: imageURLName)
      urls.append(url)
    }
    imagesURLs = urls
    
    self.description = json?[Keys.description] as? String
  }
}
