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

protocol RecipesListViewControllerDelegate: class {
  func recipesListViewControllerDidTapRecipe(recipesListViewController: RecipesListViewController,
                                             recipe: Recipe?)
}

class RecipesListViewController: UIViewController {
  weak var delegate: RecipesListViewControllerDelegate?
  
  private var viewModel: RecipesListViewModel
  
  // MARK: Outlets
  @IBOutlet private weak var recipesListTableView: UITableView!
  @IBOutlet private weak var searchRecipesBar: UISearchBar!
  @IBOutlet private weak var sortTypeTextField: UITextField!
  
  // MARK: Initializers
  init(viewModel: RecipesListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: UI setup
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = Constants.viewTitle
    
    let sortTypePicker = UIPickerView()
    sortTypePicker.delegate = self
    sortTypePicker.dataSource = self
    sortTypeTextField?.inputView = sortTypePicker
    
    searchRecipesBar?.delegate = self
    recipesListTableView?.delegate = self
    recipesListTableView?.dataSource = self
    recipesListTableView?.register(UINib.init(nibName: Constants.recipeCellNibName, bundle: nil),
                                   forCellReuseIdentifier: Constants.recipeCellIdentifier)
    self.viewModel.getRecipes(updateUIHandler: { [weak self] in
      if !Constants.sortTypesArray.isEmpty {
        self?.viewModel.sort(sortType: Constants.sortTypesArray[0])
        self?.sortTypeTextField.text = Constants.sortTypesArray[0].rawValue
      }
      
      self?.recipesListTableView.reloadData()
      }, errorHandler: { [weak self] error in
        self?.showAlert(withTitle: "Error", message: error.localizedDescription)
    })
  }
}

// MARK: UITableViewDelegate, UITableViewDelegate
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
      cell.setup(viewModel: RecipesListCellViewModel(with: viewModel.recipe(row: indexPath.row)))
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.recipesListViewControllerDidTapRecipe(recipesListViewController: self,
                                                    recipe: viewModel.recipe(row: indexPath.row))
  }
}

// MARK: UISearchBarDelegate
extension RecipesListViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.search(searchText: searchText)
    self.recipesListTableView.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}

// MARK: UIPickerViewDelegate, UIPickerViewDataSource
extension RecipesListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return Constants.sortTypesArray.count
  }
  
  func pickerView(_ pickerView: UIPickerView,
                  titleForRow row: Int,
                  forComponent component: Int) -> String? {
    return Constants.sortTypesArray[row].rawValue
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let sortType = Constants.sortTypesArray[row]
    sortTypeTextField?.text = sortType.rawValue
    viewModel.sort(sortType: sortType)
    sortTypeTextField?.resignFirstResponder()
    recipesListTableView.reloadData()
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
}

fileprivate extension UIViewController {
  func showAlert(withTitle title: String, message: String, okButtonTapped: (() -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
      okButtonTapped?()
    }
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
}
