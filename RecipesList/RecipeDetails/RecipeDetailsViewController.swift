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
  
  static let collectionViewCellIdentifier = "CollectionViewCell"
}

class RecipeDetailsViewController: UIViewController {
  private var viewModel: RecipeDetailsViewModel
  
  // MARK: Outlets
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var photosPageControl: UIPageControl!
  @IBOutlet private weak var descriptionLabel: UILabel!
  @IBOutlet private weak var instructionsTextView: UITextView!
  @IBOutlet private weak var difficultyLevelStackView: UIStackView!
  @IBOutlet private weak var photosCollectionView: UICollectionView!
  
  // MARK: Initializers
  init(viewModel: RecipeDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
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
      descriptionLabel?.text = viewModel.description
    } else {
      descriptionLabel?.isHidden = true
    }
    
    instructionsTextView?.isEditable = false
    instructionsTextView?.text = viewModel.instructions
    instructionsTextView?.contentOffset = CGPoint.zero
    
    photosCollectionView?.delegate = self
    photosCollectionView?.dataSource = self
    photosCollectionView?.register(UINib.init(nibName: "PhotosCollectionViewCell", bundle: nil),
                                  forCellWithReuseIdentifier: Constants.collectionViewCellIdentifier)
    if let layout = photosCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
    photosCollectionView?.showsHorizontalScrollIndicator = false
    photosCollectionView?.isPagingEnabled = true
    
    setupPagesControl()
    setupDifficultyLevelControl()
  }
  
  private func setupPagesControl() {
    photosPageControl?.hidesForSinglePage = true
    photosPageControl.isUserInteractionEnabled = false
    photosPageControl?.numberOfPages = viewModel.imagesCount
    
    let pageControlWidth = photosPageControl.size(forNumberOfPages: viewModel.imagesCount).width
    let mainViewWidth = view.frame.width
    if pageControlWidth > mainViewWidth {
      let scale = mainViewWidth / pageControlWidth
      photosPageControl?.transform = CGAffineTransform(scaleX: scale, y: scale)
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
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension RecipeDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.imagesCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
    if let cell = photosCollectionView?.dequeueReusableCell(withReuseIdentifier:
      Constants.collectionViewCellIdentifier, for: indexPath) as? PhotosCollectionViewCell {
      if let url = viewModel.imageURL(imageNumber: indexPath.row) {
        cell.setup(imageURL: url)
      }
      return cell
    }
    return UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didEndDisplaying cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {
    if let visibleItem = collectionView.indexPathsForVisibleItems.first?.item {
      photosPageControl?.currentPage = visibleItem
    }
  }
}

// MARK: UICollectionViewDelegateFlowLayout
extension RecipeDetailsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.bounds.size
  }
}
