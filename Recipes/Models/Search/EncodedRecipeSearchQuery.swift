//
//  EncodedRecipeSearchQuery.swift
//  RecipePuppy
//
//  Created by Daniel Illescas Romero on 18/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

struct EncodedRecipeSearchQuery {
	
	let rawQueryAPI: RecipeSearchQuery
	
	var title: URLQueryItem {
		return URLQueryItem(name: "q", value: rawQueryAPI.title)
	}
	
	var ingredients: URLQueryItem {
		return URLQueryItem(name: "i", value: rawQueryAPI.ingredients)
	}
	
	var page: URLQueryItem {
		return URLQueryItem(name: "p", value: String(rawQueryAPI.pageNumber == 0 ? 1 : rawQueryAPI.pageNumber))
	}
	
	let format = URLQueryItem(name: "format", value: "json")
	
	var allQueryItems: [URLQueryItem] {
		return [self.title, self.ingredients, self.page, self.format]
	}
}
