//
//  RecipesListCell.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class RecipesListCell: UITableViewCell {
  
  // MARK: Outlets
  @IBOutlet private weak var recipePhotoImageView: UIImageView!
  @IBOutlet private weak var recipeNameLabel: UILabel!
  @IBOutlet private weak var recipeDescriptionLabel: UILabel!
  
  // MARK: UI setup
  func setup(viewModel: RecipesListCellViewModel) {    
    recipeNameLabel?.text = viewModel.name
    recipeNameLabel?.numberOfLines = 0
    recipeNameLabel?.lineBreakMode = .byWordWrapping
    recipeNameLabel?.textColor = Constants.recipeNameColor
    
    recipeDescriptionLabel?.text = viewModel.description
    
    recipePhotoImageView.kf.setImage(with: viewModel.imageURL)
  }
}
