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
  
  init(fromJSON JSON: [String: Any]?) throws {
    if let name = JSON?["name"] as? String {
      self.name = name
    } else {
      print("Recipe::init:Cannot parse \"name\"-section")
      let error = NSError(domain: Constants.invalidJSONDataError.domain,
                          code: Constants.invalidJSONDataError.code,
                          userInfo: Constants.invalidJSONDataError.userInfo)
      throw error
    }
    
    if let imagesURLsNames = JSON?["images"] as? [String] {
      var urls = [URL?]()
      for imageURLName in imagesURLsNames {
        let url = URL(string: imageURLName)
        urls.append(url)
      }
      self.imagesURLs = urls
    } else {
      print("Recipe::init:Cannot parse \"images\"-section")
      let error = NSError(domain: Constants.invalidJSONDataError.domain,
                          code: Constants.invalidJSONDataError.code,
                          userInfo: Constants.invalidJSONDataError.userInfo)
      throw error
    }
    
    if let lastUpdated = JSON?["lastUpdated"] as? Int {
      self.lastUpdated = lastUpdated
    } else {
      print("Recipe::init:Cannot parse \"lastUpdated\"-section")
      let error = NSError(domain: Constants.invalidJSONDataError.domain,
                          code: Constants.invalidJSONDataError.code,
                          userInfo: Constants.invalidJSONDataError.userInfo)
      throw error
    }
    
    if let instructions = JSON?["instructions"] as? String {
      self.instructions = instructions
    } else {
      print("Recipe::init:Cannot parse \"instructions\"-section")
      let error = NSError(domain: Constants.invalidJSONDataError.domain,
                          code: Constants.invalidJSONDataError.code,
                          userInfo: Constants.invalidJSONDataError.userInfo)
      throw error
    }
    
    if let description = JSON?["description"] as? String {
      self.description = description
    } else {
      print("Recipe::init:Cannot parse \"description\"-section")
    }
    
    if let difficulty = JSON?["difficulty"] as? Int {
      self.difficulty = difficulty
    } else {
      print("Recipe::init:Cannot parse \"difficulty\"-section")
      let error = NSError(domain: Constants.invalidJSONDataError.domain,
                          code: Constants.invalidJSONDataError.code,
                          userInfo: Constants.invalidJSONDataError.userInfo)
      throw error
    }
  }
}
