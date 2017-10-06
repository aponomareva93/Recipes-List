//
//  RecipeDetailsViewController.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

fileprivate extension Constants {
    static let maxDifficultyLevel = 5
    static let difficultyLevelItem = "🍗"
}

protocol RecipeDetailsViewControllerDelegate: class {
    func recipeDetailsViewControllerDidTapClose(_ recipeDetailsViewController: RecipeDetailsViewController?)
}

class RecipeDetailsViewController: UIViewController {
    weak var delegate: RecipeDetailsViewControllerDelegate?
    
    private var viewModel: RecipeDetailsViewModel
    
    // MARK: Outlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var photosPageControl: UIPageControl!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var instructionsTextView: UITextView!
    @IBOutlet private weak var difficultyLevelStackView: UIStackView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
        
    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                  target: self,
                                                  action: #selector(cancelButtonTapped))
        return cancelBarButtonItem
    }()
    
    // MARK: Initializers
    init(viewModel: RecipeDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel?.numberOfLines = 0
        nameLabel?.lineBreakMode = .byWordWrapping
        nameLabel?.textColor = Constants.recipeNameColor
        nameLabel?.text = viewModel.name
        
        descriptionLabel?.numberOfLines = 0
        descriptionLabel?.lineBreakMode = .byWordWrapping
        if !viewModel.description.isEmpty {
            descriptionLabel?.text = "Description: " + viewModel.description
        } else {
            descriptionLabel?.isHidden = true
        }
        
        instructionsTextView?.isEditable = false
        instructionsTextView?.text = viewModel.instructions
        instructionsTextView?.contentOffset = CGPoint.zero
        
        setImageView()
        setupPagesControl()
        setupDifficultyLevelControl()
    }
    
    private func setupPagesControl() {
        if viewModel.imagesCount > 1 {
            photosPageControl?.numberOfPages = viewModel.imagesCount
            let pageControlWidth = photosPageControl.size(forNumberOfPages: viewModel.imagesCount).width
            let mainViewWidth = view.frame.width
            if pageControlWidth > mainViewWidth {
                let scale = mainViewWidth / pageControlWidth
                photosPageControl?.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
            photosPageControl?.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)
            
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
    
    func setupDifficultyLevelControl() {
        if viewModel.difficulty > 0 {
            for item in 0..<Constants.maxDifficultyLevel {
                let label = UILabel()
                label.text = Constants.difficultyLevelItem
                if item >= viewModel.difficulty {
                    label.alpha = 0.25
                }
                difficultyLevelStackView?.addArrangedSubview(label)
            }
        } else {
            difficultyLevelStackView?.isHidden = true
        }
    }
    
    func setImageView() {
        viewModel.getImageFromURL(imageNumber: photosPageControl.currentPage, updateUIHandler: { [weak self] data in
            self?.photoImageView?.image = UIImage(data: data)
        })
    }
    
    // MARK: Actions
    @objc private func cancelButtonTapped(sender: UIBarButtonItem) {
        delegate?.recipeDetailsViewControllerDidTapClose(self)
    }
    
    @objc private func pageControlTapHandler(sender: UIPageControl) {
        spinner.startAnimating()
        viewModel.getImageFromURL(imageNumber: photosPageControl.currentPage, updateUIHandler: { [weak self] data in
            self?.photoImageView?.image = UIImage(data: data)
            self?.spinner.stopAnimating()
        })
    }
    
    @objc private func swipePhotos(swipeGesture: UISwipeGestureRecognizer) {
        switch swipeGesture.direction {
        case .right:
            if photosPageControl.currentPage > 0 {
                photosPageControl.currentPage -= 1
                setImageView()
            }
        case .left:
            if photosPageControl.currentPage < viewModel.imagesCount - 1 {
                photosPageControl.currentPage += 1
                setImageView()
            }
        default:
            break
        }
    }
}
