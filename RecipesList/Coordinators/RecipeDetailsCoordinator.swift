//
//  RecipeDetailsCoordinator.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

protocol RecipeDetailsCoordinatorDelegate: class {
  func recipeDetailsCoordinatorDidRequestCancel(recipeDetailsCoordinator: RecipeDetailsCoordinator)
}

class RecipeDetailsCoordinator: RootViewCoordinator {
  var childCoordinators: [Coordinator] = []
  
  var rootViewController: UIViewController {
    return self.navigationController
  }
  
  weak var delegate: RecipeDetailsCoordinatorDelegate?
  
  private lazy var navigationController: UINavigationController = {
    let navigationController = UINavigationController()
    return navigationController
  }()
  
  func start(with recipe: Recipe? = nil) {
    let viewModel = RecipeDetailsViewModel(recipe: recipe)
    let recipeDetailsViewController = RecipeDetailsViewController(viewModel: viewModel)
    recipeDetailsViewController.delegate = self
    self.navigationController.viewControllers = [recipeDetailsViewController]
  }
}

extension RecipeDetailsCoordinator: RecipeDetailsViewControllerDelegate {
  func recipeDetailsViewControllerDidTapClose(_ recipeDetailsViewController: RecipeDetailsViewController?) {
    self.delegate?.recipeDetailsCoordinatorDidRequestCancel(recipeDetailsCoordinator: self)
  }
}
