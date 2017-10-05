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
}

protocol RecipesListViewControllerDelegate: class {
    func recipesListViewControllerDidTapRecipe(recipesListViewController: RecipesListViewController, recipe: Recipe?)
}

class RecipesListViewController: UIViewController {
    weak var delegate: RecipesListViewControllerDelegate?
    private var viewModel: RecipesListViewModel

    @IBOutlet private weak var recipesListTableView: UITableView!
    @IBOutlet private weak var searchRecipesBar: UISearchBar!
    
    init(viewModel: RecipesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchRecipesBar?.delegate = self
        recipesListTableView?.delegate = self
        recipesListTableView?.dataSource = self
        recipesListTableView?.register(UINib.init(nibName: "RecipesListCell", bundle: nil),
                                       forCellReuseIdentifier: Constants.recipeCellIdentifier)
        self.viewModel.getRecipes(completionHandler: { [weak self] in
            self?.recipesListTableView.reloadData()
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.recipesListViewControllerDidTapRecipe(recipesListViewController: self,
                                                        recipe: viewModel.recipe(row: indexPath.row))
    }
}

extension RecipesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchText: searchText)
        self.recipesListTableView.reloadData()
    }
}
