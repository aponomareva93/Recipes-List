//
//  RecipeDetailsViewController.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

protocol RecipeDetailsViewControllerDelegate: class {
    func recipeDetailsViewControllerDidTapClose(_ recipeDetailsViewController: RecipeDetailsViewController?)
}

class RecipeDetailsViewController: UIViewController {
    weak var delegate: RecipeDetailsViewControllerDelegate?
}
