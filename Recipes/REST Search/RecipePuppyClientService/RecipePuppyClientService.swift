//
//  RecipePuppyClientService.swift
//  Recipes
//
//  Created by Daniel Illescas Romero on 23/01/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

class RecipePuppyClientService: RestApiClientService {
	
	typealias Request = RecipePuppyApiClient.GetRecipes.Request
	typealias Response = Request.Response
	
	var restApiClient: RestApiClientProtocol = RecipePuppyApiClient()
	
	func read(_ request: Request, headers: [RestApiClient.Headers] = [],
			  completionHandler: @escaping RestApiClient.SendResponse<Response>) {
		self.restApiClient.fetch(request, method: .GET, headers: headers, completionHandler: completionHandler)
	}
}
