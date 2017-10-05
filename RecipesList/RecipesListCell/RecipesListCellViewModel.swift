//
//  RecipesListCellModel.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class RecipesListCellViewModel {
    var name: String? {
        return recipe?.name
    }
    
    var description: String? {
        return recipe?.description
    }
    
    func getImageFromURL(updateUIHandler: @escaping (_ imageData: Data) -> Void) {
        if let imagesURLs = recipe?.imagesURLs,
            !imagesURLs.isEmpty {
            DispatchQueue.global(qos: .userInitiated).async {
                if let url = imagesURLs[0] {
                    let urlContents = try? Data(contentsOf: url)
                    
                    if let imageData = urlContents, url == url {
                        DispatchQueue.main.async {
                            updateUIHandler(imageData)
                        }
                    }
                }
            }
        }
    }
    
    private var recipe: Recipe?
    
    init(with recipe: Recipe?) {
        self.recipe = recipe
    }
}
