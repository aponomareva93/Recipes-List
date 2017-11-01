//
//  ViewController.swift
//  RecipesList
//
//  Created by anna on 04.10.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

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
  private let searchController: UISearchController
  private var sortControl: UISegmentedControl?
  
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
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.sizeToFit()
    searchBarView.addSubview(searchController.searchBar)
    
    sortControl = createSortControl()
    if let sortControl = sortControl {
      sortControl.sizeToFit()
      recipesListTableView?.tableHeaderView = sortControl
    }
    
    recipesListTableView?.delegate = self
    recipesListTableView?.dataSource = self
    recipesListTableView?.register(UINib.init(nibName: Constants.recipeCellNibName, bundle: nil),
                                   forCellReuseIdentifier: Constants.recipeCellIdentifier)
    self.viewModel.getRecipes(updateUIHandler: { [weak self] in
      self?.recipesListTableView.reloadData()
      }, errorHandler: { [weak self] error in
        self?.showAlert(withTitle: "Error", message: error.localizedDescription)
    })
  }
  
  func createSortControl() -> UISegmentedControl? {
    if viewModel.sortTypesArray.isEmpty {
      return nil
    }
    
    var items = [String]()
    for sort in viewModel.sortTypesArray {
      items.append(sort.rawValue)
    }
    
    let segmentedSortControl = UISegmentedControl(items: items)
    
    segmentedSortControl.selectedSegmentIndex = 0
    segmentedSortControl.addTarget(self, action: #selector(performSort(sender:)), for: .valueChanged)
    return segmentedSortControl
  }
  
  @objc func performSort(sender: UISegmentedControl) {
    viewModel.sort(sortType: viewModel.sortTypesArray[sender.selectedSegmentIndex])
    recipesListTableView.reloadData()
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
        DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
          self?.viewModel.search(searchText: searchText)
          self?.recipesListTableView?.reloadData()
        }
      }
    } else {
      isSearching = true
      if let searchText = searchController.searchBar.text {
        searchQueue.addOperation { [weak self] in
          self?.viewModel.search(searchText: searchText)
          DispatchQueue.main.async {
            self?.recipesListTableView?.reloadData()
            if let numberOfRows = self?.recipesListTableView?.numberOfRows(inSection: 0),
              numberOfRows > 0 {
              self?.recipesListTableView?.scrollToRow(at: IndexPath(row: 0, section: 0),
                                                      at: .bottom,
                                                      animated: false)
            }
          }
          self?.isSearching = false
        }
      }
    }
  }
}
