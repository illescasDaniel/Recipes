//
//  RecipePuppyGetRecipes.swift
//  Recipes
//
//  Created by Daniel Illescas Romero on 23/01/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

extension RecipePuppyApiClient {
	
	struct GetRecipes {
		
		struct Request: RestApiClientQueryRequest {
			
			enum Format: String {
				case json
				case xml
			}
			
			typealias Response = GetRecipes.Response
			let resourceName: String = "api"
			
			let title: String
			let ingredients: String // or [Ingredient] in a future
			var pageNumber: UInt32
			let format: Format = .json
			
			var queryDictionary: [String: Encodable] { return [
				"q": self.title,
				"i": self.ingredients,
				"p": self.pageNumber,
				"format": self.format.rawValue
			]}
		}
		
		struct Response: RestApiClientResponse {
			let title: String
			let version: Double
			let href: URL
			let results: [Result]
			struct Result: Decodable {
				let title: String
				let href: URL
				let ingredients: String // separated by comma
				let thumbnail: String // empty if no thumbnail available
			}
		}
	}
}
