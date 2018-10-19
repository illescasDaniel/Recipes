//
//  PuppySearchQuery.swift
//  RecipePuppy
//
//  Created by Daniel Illescas Romero on 18/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

struct RecipeSearchQuery {
	let title: String
	let ingredients: String // [Ingredient]
	var pageNumber: UInt32
}
