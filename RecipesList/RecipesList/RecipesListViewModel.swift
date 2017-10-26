//
//  RecipesListViewModel.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

protocol RecipesListViewModelDelegate: class {
  func recipesListViewController(didSelectRecipe recipe: Recipe)
}

class RecipesListViewModel {
  weak var coordinatorDelegate: RecipesListViewModelDelegate?
  
  var recipesCount: Int {
    return recipes.count
  }
  
  private var recipesStorage = [Recipe]()
  private var recipes = [Recipe]()
  
  let sortTypesArray = [
    Constants.SortTypes.dateSort,
    Constants.SortTypes.alphabeticallySort
  ]
  var sortTypesCount: Int {
    return sortTypesArray.count
  }
  
  func getCellViewModel(forRow row: Int) -> RecipesListCellViewModel {
    let cellViewModel = RecipesListCellViewModel(with: recipes[row])
    return cellViewModel
  }
  
  func recipesListViewController(didSelectRecipeAt row: Int) {
    coordinatorDelegate?.recipesListViewController(didSelectRecipe: recipes[row])
  }
  
  func getRecipes(updateUIHandler: @escaping () -> Void,
                  errorHandler: ((_ error: NSError) -> Void)? = nil) {
    NetworkManager.fetchRecipes(completionHandler: {[weak self] (responseObject: Response<Recipe>) in
      switch responseObject {
      case .success(let recipes):
        self?.recipesStorage = recipes
        self?.recipes = recipes
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
    recipes = searchText.isEmpty ? recipesStorage : recipesStorage.filter { (item: Recipe) -> Bool in
      return (item.name.range(of: searchText,
                               options: .caseInsensitive,
                               range: nil,
                               locale: nil) != nil
        || item.description?.range(of: searchText,
                                   options: .caseInsensitive,
                                   range: nil,
                                   locale: nil) != nil
        || item.instructions.range(of: searchText,
                                    options: .caseInsensitive,
                                    range: nil,
                                    locale: nil) != nil)
    }
  }
  
  func sort(sortType: Constants.SortTypes) {
    switch sortType {
    case .alphabeticallySort:
      recipesStorage = recipesStorage.sorted {
        sortStrings(firstString: $0.name, secondString: $1.name)
      }
      recipes = recipes.sorted {
        sortStrings(firstString: $0.name, secondString: $1.name)
      }
    case .dateSort:
      recipesStorage = recipesStorage.sorted {
        sortNumbers(firstNumber: $0.lastUpdated, secondNumer: $1.lastUpdated)
      }
      recipes = recipes.sorted {
        sortNumbers(firstNumber: $0.lastUpdated, secondNumer: $1.lastUpdated)
      }
    }
  }
}

// MARK: Sorting
fileprivate extension RecipesListViewModel {
  func sortStrings(firstString: String?, secondString: String?) -> Bool {
    guard let firstString = firstString,
      let secondString = secondString else {
        return false
    }
    return firstString.localizedCaseInsensitiveCompare(secondString) == ComparisonResult.orderedAscending
  }
  
  func sortNumbers(firstNumber: Int?, secondNumer: Int?) -> Bool {
    guard let firstNumber = firstNumber,
      let secondNumer = secondNumer else {
        return false
    }
    return firstNumber > secondNumer
  }
}
