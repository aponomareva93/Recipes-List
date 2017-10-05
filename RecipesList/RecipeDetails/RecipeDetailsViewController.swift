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
        if let description = viewModel.description,
            !description.isEmpty {
            descriptionLabel?.text = description
        } else {
            descriptionLabel?.isHidden = true
        }
        
        instructionsTextView?.isEditable = false
        instructionsTextView?.text = viewModel.instructions
        
        photosPageControl?.numberOfPages = viewModel.imagesCount
        photosPageControl?.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)
        
        viewModel.getImageFromURL(imageNumber: photosPageControl.currentPage, updateUIHandler: { [weak self] data in
            self?.photoImageView?.image = UIImage(data: data)
        })
        
        if viewModel.imagesCount > 1 {
            photoImageView?.isUserInteractionEnabled = true
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipePhotos(swipeGesture:)))
            leftSwipe.direction = .left
            photoImageView?.addGestureRecognizer(leftSwipe)
            
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipePhotos(swipeGesture:)))
            rightSwipe.direction = .right
            photoImageView?.addGestureRecognizer(rightSwipe)
        } else {
            photosPageControl.isHidden = true
        }
    }
    
    @objc func pageControlTapHandler(sender: UIPageControl) {
        viewModel.getImageFromURL(imageNumber: photosPageControl.currentPage, updateUIHandler: { [weak self] data in
            self?.photoImageView?.image = UIImage(data: data)
        })
    }
    
    @objc func swipePhotos(swipeGesture: UISwipeGestureRecognizer) {
        switch swipeGesture.direction {
        case .right:
            if photosPageControl.currentPage > 0 {
                photosPageControl.currentPage -= 1
                viewModel.getImageFromURL(imageNumber: photosPageControl.currentPage, updateUIHandler: { [weak self] data in
                    self?.photoImageView?.image = UIImage(data: data)
                })
            }
        case .left:
            if photosPageControl.currentPage < viewModel.imagesCount - 1 {
                photosPageControl.currentPage += 1
                viewModel.getImageFromURL(imageNumber: photosPageControl.currentPage, updateUIHandler: { [weak self] data in
                    self?.photoImageView?.image = UIImage(data: data)
                })
            }
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
