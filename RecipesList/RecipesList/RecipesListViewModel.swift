//
//  RecipesListViewModel.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

class RecipesListViewModel {    
    var recipesCount: Int {
        return recipes.count
    }
    
    private var recipesStorage = [Recipe]() {
        didSet {
            recipes = recipesStorage
        }
    }
    
    private var recipes = [Recipe]()
    
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
                        guard let nameFirst = $0.name,
                            let nameSecond = $1.name else {
                                return false
                        }
                        return nameFirst.localizedCaseInsensitiveCompare(nameSecond) == ComparisonResult.orderedAscending
                    }
                case .dateSort:
                    recipes = recipesStorage.sorted {
                        guard let dateFirst = $0.lastUpdated,
                            let dateSecond = $1.lastUpdated else {
                                return false
                        }
                        return dateFirst > dateSecond
                    }
                }
            }
        }
    }
    
    func getRecipes(updateUIHandler: @escaping () -> Void, errorHandler: ((_ error: NSError) -> Void)? = nil) {
        NetworkManager.fetchRecipes(completion: {[weak self] (responseObject: Response<Recipe>) in
            switch responseObject {
            case .success(let recipes):
                self?.recipesStorage = recipes
                DispatchQueue.main.async {
                    updateUIHandler()
                }
            case .failure(let error):
                if errorHandler != nil {
                    DispatchQueue.main.async {
                        errorHandler?(error)
                    }
                } else {
                    print(error)
                }
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
