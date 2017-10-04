//
//  RecipesListViewModel.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

class RecipesListViewModel {
    private var recipes: [Recipe]?
    
    func getRecipes(completionHandler: @escaping () -> Void) {
        NetworkManager.fetchRecipes(completionHandler: {[weak self] (responseObject: Response<Recipe>) in
            switch responseObject {
            case .success(let recipes):
                self?.recipes = recipes
                DispatchQueue.main.async {
                    completionHandler()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    var recipesCount: Int {
        if let count = recipes?.count {
            return count
        }
        return 0
    }
}
