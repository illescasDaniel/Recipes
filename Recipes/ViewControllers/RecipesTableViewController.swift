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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.hidesSearchBarWhenScrolling = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationItem.hidesSearchBarWhenScrolling = true
	}
	
	@objc
	private func ingredientFilterButtonAction() {
		
		let ingredientsFilterAlert = UIAlertController(title: "Ingredients",
										message: "Separate by comma the ingredients you want to use as filter for the recipes search",
										preferredStyle: .alert)
		
		ingredientsFilterAlert.addTextField { textField in
			textField.apply {
				$0.placeholder = "Ingredients"
				$0.text = self.ingredients
				$0.keyboardType = .namePhonePad
				$0.keyboardAppearance = .light
				$0.addConstraint(textField.heightAnchor.constraint(equalToConstant: 25))
			}
		}
		if !self.ingredients.isEmpty {
			ingredientsFilterAlert.addAction(UIAlertAction(title: "Reset", style: .default) { _ in
				self.loadRecipes(from: RecipeSearchQuery(title: self.query.title, ingredients: "", pageNumber: 1))
			})
		}
		ingredientsFilterAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		ingredientsFilterAlert.addAction(UIAlertAction(title: "Use", style: .default) { _ in
			guard let ingredientsFilterText = ingredientsFilterAlert.textFields?.first?.text  else { return }
			self.loadRecipes(from: RecipeSearchQuery(title: self.query.title, ingredients: ingredientsFilterText, pageNumber: 1))
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
		self.presentWebInSafariVC(url: self.recipes[safe: indexPath.row]?.href)
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		if !self.query.ingredients.isEmpty {
			return "Results filtered by ingredients"
		}
		return self.query.title.isEmpty ? "Some recipes" : "Results"
	}
}

extension RecipesTableViewController: SFSafariViewControllerDelegate {}

extension RecipesTableViewController: UISearchBarDelegate, UISearchControllerDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		let searchTextTrimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
		if searchText.isEmpty {
			searchBar.endEditing(true)
		}
		self.loadRecipes(from: RecipeSearchQuery(title: searchTextTrimmed, ingredients: self.ingredients, pageNumber: 1))
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.endEditing(true)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		let searchbarHeight = self.navigationItem.searchController?.searchBar.frame.height
		self.tableView.setContentOffset(CGPoint(x: 0, y: -(searchbarHeight ?? 0) * 2), animated: false)
		self.loadRecipes(from: RecipeSearchQuery(title: "", ingredients: "", pageNumber: 1))
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

extension RecipesTableViewController: UIViewControllerPreviewingDelegate {
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		guard let indexPath = self.tableView?.indexPathForRow(at: location) else { return nil }
		let recipe = self.recipes[safe: indexPath.row]
		let recipesVC = RecipeImageViewController().apply {
			$0.image = self.images[recipe?.thumbnail ?? ""]
			$0.recipeURL = recipe?.href
		}
		return recipesVC
	}
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		guard let recipeVC = viewControllerToCommit as? RecipeImageViewController else { return }
		self.presentWebInSafariVC(url: recipeVC.recipeURL)
	}
}

// Convenience
extension RecipesTableViewController {
	
	private func setupDelegatesAndViews() {
		self.tableView.prefetchDataSource = self
		self.setupSearchBar()
		self.tableView.register(UINib(nibName: "RoundImageCell", bundle: nil), forCellReuseIdentifier: "RoundImageCell")
		if self.traitCollection.forceTouchCapability == .available, let tableView = self.tableView {
			self.registerForPreviewing(with: self, sourceView: tableView)
		}
	}
	
	private func setupSearchBar() {
		self.definesPresentationContext = true
		self.navigationItem.apply {
			$0.hidesSearchBarWhenScrolling = true
			$0.searchController = UISearchController(searchResultsController: nil).apply {
				$0.delegate = self
				$0.searchBar.apply {
					$0.delegate = self
					$0.tintColor = self.view.tintColor
				}
				$0.obscuresBackgroundDuringPresentation = false
			}
		}
	}
	
	private func loadRecipes(from newQuery: RecipeSearchQuery) {
		self.ingredients = newQuery.ingredients
		self.query = newQuery
		self.loadRecipes()
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
		let noRecipesLabel = UILabel(frame: self.view.bounds).apply {
			$0.text = "No recipes"
			$0.textColor = .gray
			$0.numberOfLines = 0
			$0.textAlignment = .center
			$0.font = .preferredFont(forTextStyle: .title2)
			$0.sizeToFit()
		}
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
	
	private func presentWebInSafariVC(url: URL?) {
		guard let url = url else { return }
		let config = SFSafariViewController.Configuration().apply {
			$0.entersReaderIfAvailable = true
		}
		let safariVC = SFSafariViewController(url: url, configuration: config).apply {
			$0.delegate = self
			$0.preferredControlTintColor = self.view.tintColor
		}
		self.present(safariVC, animated: true)
	}
}
