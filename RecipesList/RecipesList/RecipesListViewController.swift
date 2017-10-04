//
//  ViewController.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

protocol RecipesListViewControllerDelegate: class {
    func recipesListViewControllerDidTapRecipe(recipesListViewController: RecipesListViewController)
}

class RecipesListViewController: UIViewController {
    weak var delegate: RecipesListViewControllerDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

