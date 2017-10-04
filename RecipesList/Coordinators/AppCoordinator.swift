//
//  AppCoordinator.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class AppCoordinator: RootViewCoordinator {

    var childCoordinators: [Coordinator] = []

    var rootViewController: UIViewController {
        return self.navigationController
    }

    private let window: UIWindow

    private lazy var navigationController: UINavigationController = UINavigationController()

    init(window: UIWindow) {
        self.window = window

        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }

    func start() {
        self.showContactsListViewController()
    }

    private func showContactsListViewController() {
        let viewModel = RecipesListViewModel()
        let recipesListViewController = RecipesListViewController(viewModel: viewModel)
        recipesListViewController.delegate = self
        self.navigationController.viewControllers = [recipesListViewController]
    }

}

extension AppCoordinator: RecipesListViewControllerDelegate {
    func recipesListViewControllerDidTapRecipe(recipesListViewController: RecipesListViewController) {
        let recipeDeatilsCoordinator = RecipeDetailsCoordinator()
        recipeDeatilsCoordinator.delegate = self
        recipeDeatilsCoordinator.start()
        self.addChildCoordinator(recipeDeatilsCoordinator)
        self.rootViewController.present(recipeDeatilsCoordinator.rootViewController, animated: true, completion: nil)
    }
}

extension AppCoordinator: RecipeDetailsCoordinatorDelegate {
    func recipeDetailsCoordinatorDidRequestCancel(recipeDetailsCoordinator: RecipeDetailsCoordinator) {
        recipeDetailsCoordinator.rootViewController.dismiss(animated: true)
        self.removeChildCoordinator(recipeDetailsCoordinator)
    }
}
