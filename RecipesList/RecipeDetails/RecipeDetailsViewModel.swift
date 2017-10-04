//
//  RecipeDetailsViewModel.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Foundation

class RecipeDetailsViewModel {
    private let recipe: Recipe?
    
    init(recipe: Recipe? = nil) {
        self.recipe = recipe
    }
}
