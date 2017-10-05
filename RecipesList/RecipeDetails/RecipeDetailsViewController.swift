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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photosPageControl: UIPageControl!    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    weak var delegate: RecipeDetailsViewControllerDelegate?
    private var viewModel: RecipeDetailsViewModel
    
    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                  target: self,
                                                  action: #selector(cancelButtonTapped))
        return cancelBarButtonItem
    }()
    
    @objc func cancelButtonTapped(sender: UIBarButtonItem) {
        delegate?.recipeDetailsViewControllerDidTapClose(self)
    }
    
    init(viewModel: RecipeDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel?.numberOfLines = 0
        nameLabel?.lineBreakMode = .byWordWrapping
        nameLabel?.textColor = Constants.recipeNameColor
        nameLabel?.text = viewModel.name
        
        descriptionLabel?.numberOfLines = 0
        descriptionLabel?.lineBreakMode = .byWordWrapping
        descriptionLabel?.text = viewModel.description
        
        instructionsTextView?.isEditable = false
        if let instructions = viewModel.instructions {
            instructionsTextView?.text = instructions.replacingOccurrences(of: "<br>",
                                                                           with: "\n",
                                                                           options: .regularExpression,
                                                                           range: nil)
        }
        
        /*let scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(descriptionLabel)*/
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
