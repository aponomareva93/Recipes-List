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

struct Recipe: JSONMappable {
  let name: String
  let imagesURLs: [URL?]
  let lastUpdated: Int
  let instructions: String
  var description: String?
  let difficulty: Int
  
  init(fromJSON json: [String: Any]?) throws {
    guard let name = json?["name"] as? String,
    let imagesURLsNames = json?["images"] as? [String],
    let lastUpdated = json?["lastUpdated"] as? Int,
    let instructions = json?["instructions"] as? String,
    let difficulty = json?["difficulty"] as? Int else {
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
    
    self.description = json?["description"] as? String
  }
}
