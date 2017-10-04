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
        recipeNameLabel?.text = viewModel.name
        recipeDescriptionLabel?.text = viewModel.description
        viewModel.getImageFromURL(updateUIHandler: { [weak self] data in
            self?.recipePhotoImageView.image = UIImage(data: data)
        })
    }
}
