//
//  AppCoordinator.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
  var rootViewController: UIViewController {
    return navigationController
  }
  
  private let navigationController: UINavigationController = UINavigationController()
  
  private lazy var cancelBarButtonItem: UIBarButtonItem = {
    let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                              target: self,
                                              action: #selector(cancelButtonTapped))
    return cancelBarButtonItem
  }()
  
  private let window: UIWindow
  
  init(window: UIWindow) {
    self.window = window
    
    self.window.rootViewController = self.rootViewController
    self.window.makeKeyAndVisible()
  }
  
  func start() {
    showRecipesListViewController()
  }
  
  private func showRecipesListViewController() {
    let recipesListViewModel = RecipesListViewModel()
    recipesListViewModel.coordinatorDelegate = self
    let recipesListViewController = RecipesListViewController(viewModel: recipesListViewModel)
    navigationController.viewControllers = [recipesListViewController]
  }
  
  @objc private func cancelButtonTapped(sender: UIBarButtonItem) {
    navigationController.popViewController(animated: true)
  }
}

extension AppCoordinator: RecipesListViewModelDelegate {
  func recipesListViewController(didSelectRecipe recipe: Recipe) {
    let recipeDetailsViewModel = RecipeDetailsViewModel(recipe: recipe)
    let recipeDetailsViewController = RecipeDetailsViewController(viewModel: recipeDetailsViewModel)
    navigationController.pushViewController(recipeDetailsViewController, animated: true)
    navigationController.navigationItem.leftBarButtonItem = cancelBarButtonItem
    
    let titleLabel = UILabel()
    titleLabel.text = recipeDetailsViewModel.name
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0
    guard let lastViewController = navigationController.viewControllers.last
      as? RecipeDetailsViewController else {
      return
    }
    lastViewController.navigationItem.titleView = titleLabel
  }
}
