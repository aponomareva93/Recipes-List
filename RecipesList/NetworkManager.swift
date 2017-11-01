//
//  NetworkManager.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Alamofire

fileprivate extension Constants {
  static let invalidURLError = (domain: "recipe domain",
                                code: 1,
                                userInfo: [NSLocalizedDescriptionKey:
                                  "Cannot create url for current request"])
  static let invalidJSONResponseError = (domain: "recipe domain",
                                         code: 2,
                                         userInfo: [NSLocalizedDescriptionKey:
                                          "Cannot create JSON from response"])
  static let recipesAPIUrl = "https://test.space-o.ru/recipes.json"
  static let recipesJSONArrayName = "recipes"
}

protocol JSONMappable {
  init(fromJSON json: JSON?) throws
}

enum Response<T: JSONMappable> {
  case success(T)
  case failure(NSError)
}

struct RecipesResponse: JSONMappable {
  var recipes = [Recipe]()
  
  init(fromJSON json: JSON?) throws {
    if let dictionary = json as? [String: [JSON]],
      let jsonArray = dictionary[Constants.recipesJSONArrayName] {
      for jsonElement in jsonArray {
        do {
          let recipe = try Recipe(fromJSON: jsonElement)
          recipes.append(recipe)
        } catch {
          throw error
        }
      }
    }
  }
}

class NetworkManager {
  class func baseRequest<T>(url: URLConvertible?,
                            method: HTTPMethod,
                            completion: @escaping (Response<T>) -> Void) {
    
    guard let url = url else {
      let error = NSError(domain: Constants.invalidURLError.domain,
                          code: Constants.invalidURLError.code,
                          userInfo: Constants.invalidURLError.userInfo)
      completion(.failure(error))
      return
    }
    
    Alamofire.request(
      url,
      method: method)
      .validate()
      .responseJSON(completionHandler: {response in
        switch response.result {
        case .success(let value):
          if let value = value as? JSON {
          do {
            let object = try T(fromJSON: value)
            completion(.success(object))
          } catch {
            completion(.failure(error as NSError))
            }
          } else {
            print("NetworkManager::Cannot create JSON from response")
            let error = NSError(domain: Constants.invalidJSONResponseError.domain,
                                code: Constants.invalidJSONResponseError.code,
                                userInfo: Constants.invalidJSONResponseError.userInfo)
            completion(.failure(error))
          }
        case .failure(let error):
          completion(.failure(error as NSError))
        }
      })
  }
  
  class func fetchRecipes(completionHandler: @escaping (Response<RecipesResponse>) -> Void) {
    let url = URL(string: Constants.recipesAPIUrl)
    baseRequest(url: url, method: .get, completion: completionHandler)
  }
}
