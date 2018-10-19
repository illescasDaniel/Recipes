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
	
	var title: RestParameter<String> {
		return RestParameter(parameter: "q", value: rawQueryAPI.title)
	}
	
	var ingredients: RestParameter<String> {
		return RestParameter(parameter: "i",
							 value: rawQueryAPI.ingredients)/*rawQueryAPI.ingredients
								.map { $0.urlFormat ?? "" }
								.joined(separator: ","))*/
	}
	
	var page: RestParameter<UInt> {
		return RestParameter(parameter: "p", value: UInt(rawQueryAPI.pageNumber == 0 ? 1 : rawQueryAPI.pageNumber))
	}
	
	let format = RestParameter(parameter: "format", value: "json")
}
