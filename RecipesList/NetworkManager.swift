//
//  NetworkManager.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

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
    class func fetchRecipes<T>(completion: @escaping (Response<T>) -> Void) {
        let url = URL(string: Constants.recipesAPIUrl)
        if let url = url {
            URLSession.shared.dataTask(with: url, completionHandler: {(data, _, error) -> Void in
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!,
                                                                   options: .allowFragments) as? [String: Any],
                    let dictionary = jsonObj,
                        let JSONArray = dictionary[Constants.RecipesJSONArrayName] as? [[String: Any]] {
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
                    let error = NSError(domain: Constants.invalidJSONResponseError.domain,
                                                   code: Constants.invalidJSONResponseError.code,
                                                   userInfo: Constants.invalidJSONResponseError.userInfo)
                        completion(.failure(error))
                    }
            }).resume()
        } else {
            let error = NSError(domain: Constants.invalidURLError.domain,
                                code: Constants.invalidURLError.code,
                                userInfo: Constants.invalidURLError.userInfo)
            completion(.failure(error))
        }
    }
}
