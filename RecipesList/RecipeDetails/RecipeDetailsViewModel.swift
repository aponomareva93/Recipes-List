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
    
    var name: String {
        return recipe?.name ?? String()
    }
    
    var description: String {
        return recipe?.description ?? String()
    }
    
    var instructions: String {
        if let instructions = recipe?.instructions {
            return instructions.replaceBrByNewLine()
        }
        return String()
    }
    
    var imagesCount: Int {
        return recipe?.imagesURLs?.count ?? 0
    }
    
    var difficulty: Int {
        if let difficultyLevel = recipe?.difficulty {
            return difficultyLevel
        }
        return 0
    }
    
    init(recipe: Recipe? = nil) {
        self.recipe = recipe
    }
    
    func getImageFromURL(imageNumber: Int, updateUIHandler: @escaping (_ imageData: Data) -> Void) {
        if let imagesURLs = recipe?.imagesURLs,
            imagesURLs.indices.contains(imageNumber) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let url = imagesURLs[imageNumber] {
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
}

fileprivate extension String {
    func replaceBrByNewLine() -> String {
        return self.replacingOccurrences(of: "<br>",
                                         with: "\n",
                                         options: .regularExpression,
                                         range: nil)
    }
}
