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
  static let RecipesJSONArrayName = "recipes"
}

protocol JSONMappable {
  init(fromJSON JSON: [String: Any]?) throws
}

enum Response<T: JSONMappable> {
  case success([T])
  case failure(NSError)
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
          if let dictionary = value as? [String: [[String: Any]]],
            let JSONArray = dictionary[Constants.RecipesJSONArrayName] {
            var JSONElementsArray = [T]()
            for JSONElement in JSONArray {
              do {
                let object = try T(fromJSON: JSONElement)
                JSONElementsArray.append(object)
              } catch {
                completion(.failure(error as NSError))
              }
            }
            completion(.success(JSONElementsArray))
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
  
  class func fetchRecipes<T>(completionHandler: @escaping (Response<T>) -> Void) {
    let url = URL(string: Constants.recipesAPIUrl)
    if let url = url {
      baseRequest(url: url, method: .get, completion: completionHandler)
    } else {
      let error = NSError(domain: Constants.invalidURLError.domain,
                          code: Constants.invalidURLError.code,
                          userInfo: Constants.invalidURLError.userInfo)
      completionHandler(.failure(error))
    }
  }
}
