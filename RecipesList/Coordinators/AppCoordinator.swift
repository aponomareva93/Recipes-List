//
//  AppCoordinator.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

extension AppCoordinator: RecipesListViewModelDelegate {
  func recipesListViewController(didSelectRecipe recipe: Recipe) {
    showRecipeDetailsViewController(for: recipe)
  }
}

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
  
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0
    return titleLabel
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
  
  private func showRecipeDetailsViewController(for recipe: Recipe) {
    let recipeDetailsViewModel = RecipeDetailsViewModel(recipe: recipe)
    let recipeDetailsViewController = RecipeDetailsViewController(viewModel: recipeDetailsViewModel)
    navigationController.pushViewController(recipeDetailsViewController, animated: true)
    
    titleLabel.text = recipeDetailsViewModel.name
    recipeDetailsViewController.navigationItem.titleView = titleLabel
    navigationController.navigationItem.leftBarButtonItem = cancelBarButtonItem
  }
  
  @objc private func cancelButtonTapped(sender: UIBarButtonItem) {
    navigationController.popViewController(animated: true)
  }
}
