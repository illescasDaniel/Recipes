//
//  RecipePuppy.swift
//  RecipePuppy
//
//  Created by Daniel Illescas Romero on 18/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

struct RecipeQueryResult: Codable {
	let title: String
	let version: Double
	let href: URL
	let results: [Recipe]
}
