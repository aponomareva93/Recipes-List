//
//  RecipesListCell.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class RecipesListCell: UITableViewCell {
    
    @IBOutlet private weak var recipePhotoImageView: UIImageView!
    @IBOutlet private weak var recipeNameLabel: UILabel!
    @IBOutlet private weak var recipeDescriptionLabel: UILabel!
    
    func setup(viewModel: RecipesListCellViewModel) {
        frame.size.height = Constants.recipeDetailsCellHeight
        
        recipeNameLabel?.text = viewModel.name
        recipeNameLabel?.numberOfLines = 0
        recipeNameLabel?.lineBreakMode = .byWordWrapping
        recipeNameLabel?.textColor = Constants.recipeNameColor
        
        recipeDescriptionLabel?.text = viewModel.description
        viewModel.getImageFromURL(updateUIHandler: { [weak self] data in
            self?.recipePhotoImageView.image = UIImage(data: data)
        })
    }
}
