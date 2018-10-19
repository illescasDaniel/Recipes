//
//  RecipesTableViewController.swift
//  RecipePuppy
//
//  Created by Daniel Illescas Romero on 18/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import UIKit
import SafariServices

class RecipesTableViewController: UITableViewController {

	@IBOutlet weak var recipesSearchBar: UISearchBar!
	
	private var query = RecipeSearchQuery(title: "", ingredients: "", pageNumber: 1)
	
	private var recipes: [Recipe] = []
	private var ingredients: String = "" // [Ingredient] when "enum Ingredient" is completed
	private var images: [String: UIImage] = [:]
	
	private let downloadManager = DownloadManager()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
		
		self.setupDelegatesAndViews()
		
		self.loadRecipes()
		
		self.navigationItem.rightBarButtonItem?.target = self
		self.navigationItem.rightBarButtonItem?.action = #selector(self.ingredientFilterButtonAction)
    }
	
	@objc
	private func ingredientFilterButtonAction() {
		
		let ingredientsFilterAlert = UIAlertController(title: "Ingredients",
										message: "Separate by comma the ingredients you want to use as filters for the recipes search",
										preferredStyle: .alert)
		
		ingredientsFilterAlert.addTextField { textField in
			textField.placeholder = "Ingredients"
			textField.text = self.ingredients
			textField.keyboardType = .namePhonePad
			textField.keyboardAppearance = .light
			textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 25))
		}
		if !self.ingredients.isEmpty {
			ingredientsFilterAlert.addAction(UIAlertAction(title: "Reset", style: .default) { _ in
				self.ingredients = ""
				let newQuery = RecipeSearchQuery(title: self.query.title, ingredients: self.ingredients, pageNumber: 1)
				self.query = newQuery
				self.loadRecipes()
			})
		}
		ingredientsFilterAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		ingredientsFilterAlert.addAction(UIAlertAction(title: "Use", style: .default) { _ in
			if let ingredientsFilterText = ingredientsFilterAlert.textFields?.first?.text {
				self.ingredients = ingredientsFilterText
				let newQuery = RecipeSearchQuery(title: self.query.title, ingredients: self.ingredients, pageNumber: 1)
				self.query = newQuery
				self.loadRecipes()
			}
		})
		self.present(ingredientsFilterAlert, animated: true)
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		tableView.backgroundView = self.recipes.isEmpty ? self.emptySearchBackgroundView() : nil
        return self.recipes.count
    }
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		DispatchQueue.main.async {
			guard let recipe = self.recipes[safe: indexPath.row] else { return }
			cell.textLabel?.text = recipe.title
			cell.detailTextLabel?.text = recipe.ingredients
			if let image = self.images[recipe.thumbnail] {
				cell.imageView?.image = image
			} else {
				cell.imageView?.image = UIImage(imageLiteralResourceName: "placeholder")
				self.downloadThumbnailAt(indexPath: indexPath)
			}
		}
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "RoundImageCell", for: indexPath)

		DispatchQueue.global().async {
			self.preloadNextPages(currentRow: indexPath.row)
		}
		
		if indexPath.row < 10 {
			DispatchQueue.main.async {
				guard let recipe = self.recipes[safe: indexPath.row] else { return }
				if let image = self.images[recipe.thumbnail] {
					cell.imageView?.image = image
				} else {
					self.downloadThumbnailAt(indexPath: indexPath, loadInto: cell.imageView)
				}
			}
		}
		
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let recipe = self.recipes[safe: indexPath.row] else { return }
		let config = SFSafariViewController.Configuration()
		config.entersReaderIfAvailable = true
		let safariVC = SFSafariViewController(url: recipe.href, configuration: config)
		safariVC.delegate = self
		safariVC.preferredControlTintColor = self.view.tintColor
		self.present(safariVC, animated: true)
	}
}

extension RecipesTableViewController: SFSafariViewControllerDelegate {}

extension RecipesTableViewController: UISearchBarDelegate {
	
	// TODO: provide ingredients
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		let searchTextTrimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
		if searchText.isEmpty {
			searchBar.endEditing(true)
		}
		self.query = RecipeSearchQuery(title: searchTextTrimmed, ingredients: self.ingredients, pageNumber: 1)
		self.loadRecipes()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.endEditing(true)
	}
}

extension RecipesTableViewController: UITableViewDataSourcePrefetching {
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		 indexPaths.forEach { self.downloadThumbnailAt(indexPath: $0) }
	}
	func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
		indexPaths.forEach {
			if let recipe = self.recipes[safe: $0.row], let url = URL(string: recipe.thumbnail) {
				self.downloadManager.cancelTaskWith(url: url)
			}
		}
	}
}


// Convenience
extension RecipesTableViewController {
	
	private func setupDelegatesAndViews() {
		self.recipesSearchBar.delegate = self
		self.tableView.prefetchDataSource = self
		self.tableView.register(UINib(nibName: "RoundImageCell", bundle: nil), forCellReuseIdentifier: "RoundImageCell")
	}

	private func downloadThumbnailAt(indexPath: IndexPath, loadInto imageView: UIImageView? = nil) {
		guard let thumbnail = self.recipes[safe: indexPath.row]?.thumbnail, let thumbnailURL = URL(string: thumbnail) else { return }
		self.downloadManager.manageData(from: thumbnailURL) { data in
			guard let data = data, let image = UIImage(data: data) else { return }
			self.images[thumbnail] = image
			imageView?.image = image
		}
	}
	
	private func emptySearchBackgroundView() -> UIView {
		let noRecipesLabel = UILabel(frame: self.view.bounds)
		noRecipesLabel.text = "No recipes"
		noRecipesLabel.textColor = .gray
		noRecipesLabel.numberOfLines = 0;
		noRecipesLabel.textAlignment = .center;
		noRecipesLabel.font = UIFont.preferredFont(forTextStyle: .title2)
		noRecipesLabel.sizeToFit()
		return noRecipesLabel
	}
	
	private func preloadNextPages(currentRow: Int) {
		if currentRow == self.recipes.count-8 {
			self.loadNextPageOfRecipes()
		}
	}
	
	private func loadRecipes() {
		self.query.pageNumber = 1
		RecipesSearch(query: self.query).manageRecipes { recipes in
			self.recipes = recipes
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	private func loadNextPageOfRecipes() {
		let pagesToAdvance: UInt32 = 2
		self.query.pageNumber += pagesToAdvance
		RecipesSearch(query: self.query).managePagesOfRecipes(pages: pagesToAdvance, { nextRecipes in
			if (self.recipes.count + nextRecipes.count) > self.recipes.count {
				self.recipes += nextRecipes
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
		})
	}
}
