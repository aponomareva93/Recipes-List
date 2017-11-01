//
//  ViewController.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit
import SVProgressHUD

fileprivate extension Constants {
  static let recipeCellIdentifier = "Recipe Cell"
  static let recipeCellNibName = "RecipesListCell"
  static let viewTitle = "Recipes"
}

class RecipesListViewController: UIViewController {
  private var viewModel: RecipesListViewModel
  
  private var isSearching: Bool
  private let searchQueue = OperationQueue()
  
  // MARK: Outlets
  @IBOutlet private weak var recipesListTableView: UITableView!
  @IBOutlet private weak var searchBarView: UIView!
  @IBOutlet private weak var noResultsLabel: UILabel!
  @IBOutlet private weak var sortControl: UISegmentedControl!
  private let searchController: UISearchController
  
  // MARK: Initializers
  init(viewModel: RecipesListViewModel) {
    self.viewModel = viewModel
    isSearching = false
    searchController = UISearchController(searchResultsController: nil)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: UI setup
  override func viewDidLoad() {
    super.viewDidLoad()
    title = Constants.viewTitle
    
    definesPresentationContext = true
    searchController.searchBar.searchBarStyle = .minimal
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.sizeToFit()
    searchBarView?.addSubview(searchController.searchBar)
    
    if viewModel.sortTypesCount < 2 {
      sortControl?.isHidden = true
    } else {
      sortControl?.removeAllSegments()
      for sort in viewModel.sortTypesArray {
        sortControl?.insertSegment(withTitle: sort.rawValue,
                                  at: sortControl.numberOfSegments,
                                  animated: false)
      }
      sortControl?.selectedSegmentIndex = 0
      sortControl?.addTarget(self, action: #selector(performSort(sender:)), for: .valueChanged)
    }
    
    recipesListTableView?.delegate = self
    recipesListTableView?.dataSource = self
    recipesListTableView?.register(UINib.init(nibName: Constants.recipeCellNibName, bundle: nil),
                                   forCellReuseIdentifier: Constants.recipeCellIdentifier)
    
    SVProgressHUD.show(withStatus: "Loading")
    self.viewModel.getRecipes(updateUIHandler: { [weak self] in
      self?.recipesListTableView.reloadData()
      SVProgressHUD.dismiss()
      }, errorHandler: { [weak self] error in
        SVProgressHUD.dismiss()
        self?.showAlert(withTitle: "Error", message: error.localizedDescription)
    })
  }
  
  @objc private func performSort(sender: UISegmentedControl) {
    viewModel.sort(sortType: viewModel.sortTypesArray[sender.selectedSegmentIndex])
    recipesListTableView?.reloadData()
  }
  
  private func showSearchResults() {
    self.recipesListTableView?.reloadData()
    if viewModel.recipesCount > 0 {
      recipesListTableView?.isHidden = false
      noResultsLabel?.isHidden = true
      if viewModel.sortTypesCount > 1 {
        sortControl?.isHidden = false
      }
    } else {
      recipesListTableView?.isHidden = true
      noResultsLabel?.isHidden = false
    }
  }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension RecipesListViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.recipesCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier:
      Constants.recipeCellIdentifier, for: indexPath) as? RecipesListCell {
      let cellModel = viewModel.getCellViewModel(forRow: indexPath.row)
      cell.setup(viewModel: cellModel)
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.recipesListViewController(didSelectRecipeAt: indexPath.row)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    if searchController.searchBar.isFirstResponder {
      searchController.searchBar.resignFirstResponder()
    }
  }
}

// MARK: UISearchResultsUpdating
extension RecipesListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if isSearching {
      let delay = DispatchTime.now() + 1
      searchQueue.cancelAllOperations()
      isSearching = false      
      if let searchText = searchController.searchBar.text {
        searchQueue.addOperation {
          DispatchQueue.global().asyncAfter(deadline: delay) { [weak self] in
            self?.viewModel.search(searchText: searchText)
            DispatchQueue.main.async {
              self?.showSearchResults()
            }
          }          
        }
      }
    } else {
      isSearching = true
      if let searchText = searchController.searchBar.text {
        searchQueue.addOperation { [weak self] in
          self?.viewModel.search(searchText: searchText)
          DispatchQueue.main.async {
            self?.showSearchResults()
          }
          self?.isSearching = false
        }
      }
    }
  }
}
