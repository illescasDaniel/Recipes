//
//  RecipePuppyResult.swift
//  RecipePuppy
//
//  Created by Daniel Illescas Romero on 18/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

struct Recipe: Codable, Hashable {
	
	let title: String
	let href: URL
	let ingredients: String // separated by comma
	let thumbnail: String // empty if no thumbnail available
	
	var toImprovedRecipe: ImprovedRecipe {
		let trimmedTitle = self.title.trimmingCharacters(in: .whitespacesAndNewlines)
		let typedIngredients = self.ingredients.components(separatedBy: ", ").map { Ingredient(rawValue: $0) ?? .unknown }
		let trimmedThumbnail = self.thumbnail.trimmingCharacters(in: .whitespacesAndNewlines)
		//let typedURL =  isEmpty ? nil : URL(string: self.thumbnail)
		return ImprovedRecipe(title: trimmedTitle, href: self.href, ingredients: typedIngredients, thumbnail: trimmedThumbnail) //typedURL)
	}
}
