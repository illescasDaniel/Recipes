//
//  RecipePuppySearch.swift
//  RecipePuppy
//
//  Created by Daniel Illescas Romero on 18/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

class RecipesSearch {
	
	static let apiURL = "http://www.recipepuppy.com/api/?"
	
	var query: RecipeSearchQuery
	
	init(query: RecipeSearchQuery) {
		self.query = query
	}
	
	func manageRecipes(_ result: @escaping (([Recipe]) -> Void)) {
		DispatchQueue.global().async {
			result(self.getRecipePuppy?.results ?? [])
		}
	}
	
	func managePagesOfRecipes(pages: UInt32, _ result: @escaping (([Recipe]) -> Void)) {
		DispatchQueue.global().async {
			var recipes: [Recipe] = []
			let otherRecipePuppySearch = RecipesSearch(query: self.query)
			for _ in 0..<pages {
				recipes += self.getRecipePuppy?.results ?? []
				otherRecipePuppySearch.query.pageNumber += 1
			}
			result(recipes)
		}
	}
	
	// - Convenience
	
	var apiQueryURL: URL? {
		
		let encodedQuery = EncodedRecipeSearchQuery(rawQueryAPI: self.query)
		let (ingredients, title, pageNumber, format) = (encodedQuery.ingredients.urlParameter, encodedQuery.title.urlParameter,
														encodedQuery.page.urlParameter, encodedQuery.format.urlParameter)
		return URL(string: RecipesSearch.apiURL + [ingredients, title, pageNumber, format].joined(separator: "&"))
	}
	
	var getRecipePuppy: RecipeQueryResult? {
		if let validAPIQueryURL = self.apiQueryURL, let jsonDataResponse = try? Data(contentsOf: validAPIQueryURL) {
			if let recipePuppyQuery = try? JSONDecoder().decode(RecipeQueryResult.self, from: jsonDataResponse) {
				return recipePuppyQuery
			}
		}
		return nil
	}
}
