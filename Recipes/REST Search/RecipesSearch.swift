//
//  RecipePuppySearch.swift
//  RecipePuppy
//
//  Created by Daniel Illescas Romero on 18/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

class RecipesSearch {
	
	private static let recipePuppyService = RecipePuppyClientService()
	
	var query: RecipePuppyClientService.Request
	init(query: RecipePuppyClientService.Request) {
		self.query = query
	}
	
	func manageRecipes(_ resultCompletionHandler: @escaping RestApiClient.SendResponse<RecipePuppyClientService.Response>) {
		RecipesSearch.recipePuppyService.read(self.query, completionHandler: resultCompletionHandler)
	}
}
