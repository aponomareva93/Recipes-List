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
    
    var sortType: Constants.SortTypes? {
        didSet {
            if let sortType = sortType {
                switch sortType {
                case .alphabeticallySort:
                    recipes = recipesStorage.sorted {
                        $0.name!.localizedCaseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending
                    }
                case .dateSort:
                    recipes = recipesStorage.sorted {
                        $0.lastUpdated! > $1.lastUpdated!
                    }
                }
            }
        }
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
