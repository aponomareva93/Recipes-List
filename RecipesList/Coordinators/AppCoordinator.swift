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
    let recipesListViewController = RecipesListViewController(viewModel: recipesListViewModel)
    recipesListViewController.coordinatorDelegate = self
    navigationController.viewControllers = [recipesListViewController]
  }
  
  @objc private func cancelButtonTapped(sender: UIBarButtonItem) {
    navigationController.popViewController(animated: true)
  }
}

extension AppCoordinator: RecipesListViewControllerDelegate {
  func recipesListViewController(didSelectRecipe recipe: Recipe) {
    let recipeDetailsViewModel = RecipeDetailsViewModel(recipe: recipe)
    let recipeDetailsViewController = RecipeDetailsViewController(viewModel: recipeDetailsViewModel)
    navigationController.pushViewController(recipeDetailsViewController, animated: true)
    navigationController.navigationItem.leftBarButtonItem = cancelBarButtonItem
  }
}
