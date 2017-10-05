//
//  RecipesListViewModel.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

class RecipesListViewModel {
    private var recipesStorage = [Recipe]() {
        didSet {
            recipes = recipesStorage
        }
    }
    
    private var recipes = [Recipe]()
    
    var recipesCount: Int {
        return recipes.count
    }
    
    func recipe(row: Int) -> Recipe? {
        if recipes.indices.contains(row) {
            return recipes[row]
        }
        return nil
    }
    
    func getRecipes(completionHandler: @escaping () -> Void) {
        NetworkManager.fetchRecipes(completionHandler: {[weak self] (responseObject: Response<Recipe>) in
            switch responseObject {
            case .success(let recipes):
                self?.recipesStorage = recipes
                DispatchQueue.main.async {
                    completionHandler()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func search(searchText: String) {
        let filteredData = searchText.isEmpty ? recipesStorage : recipesStorage.filter { (item: Recipe) -> Bool in
            return (item.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                || item.description?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                || item.instructions?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
        }
        recipes = filteredData
    }
}
