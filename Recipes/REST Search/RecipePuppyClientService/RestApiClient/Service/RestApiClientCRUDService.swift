//
//  RestApiClientCRUDService.swift
//  RestApiClient
//
//  Created by Daniel Illescas Romero on 22/01/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

protocol RestApiClientCRUDService: RestApiClientService {
	
	associatedtype CreateRequestType: RestApiClientQueryRequest
	associatedtype CreateBodyType: RestApiClientBodyRequest
	
	associatedtype ReadRequestType: RestApiClientQueryRequest
	
	associatedtype UpdateRequestType: RestApiClientQueryRequest
	associatedtype UpdateBodyType: RestApiClientBodyRequest
	
	associatedtype DeleteRequestType: RestApiClientQueryRequest
}

extension RestApiClientCRUDService {
	func create(_ request: CreateRequestType, body: CreateBodyType, headers: [RestApiClient.Headers] = [],
				completionHandler: @escaping RestApiClient.SendResponse<CreateRequestType.Response>) {
		self.restApiClient.fetch(request, method: .POST, body: body, headers: headers, completionHandler: completionHandler)
	}
	func read(_ request: ReadRequestType, headers: [RestApiClient.Headers] = [],
				completionHandler: @escaping RestApiClient.SendResponse<ReadRequestType.Response>) {
		self.restApiClient.fetch(request, method: .GET, headers: headers, completionHandler: completionHandler)
	}
	func update(_ request: UpdateRequestType, body: UpdateBodyType, headers: [RestApiClient.Headers] = [],
				completionHandler: @escaping RestApiClient.SendResponse<UpdateRequestType.Response>) {
		self.restApiClient.fetch(request, method: .PUT, body: body, headers: headers, completionHandler: completionHandler)
	}
	func delete(_ request: DeleteRequestType, headers: [RestApiClient.Headers] = [],
				completionHandler: @escaping RestApiClient.SendResponse<DeleteRequestType.Response>) {
		self.restApiClient.fetch(request, method: .DELETE, headers: headers, completionHandler: completionHandler)
	}
}
