//
//  RestApiClient.swift
//  RestApiClient
//
//  Created by Daniel Illescas Romero on 16/01/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

protocol RestApiClientProtocol {
	
	var baseURL: String { get }
	
	func fetch<Request: RestApiClientQueryRequest, Body: RestApiClientBodyRequest>(_ request: Request, method: RestApiClient.HTTPMethod,
																  body: Body, headers: [RestApiClient.Headers],
																  completionHandler: @escaping RestApiClient.SendResponse<Request.Response>)
	func fetch<Request: RestApiClientQueryRequest>(_ request: Request, method: RestApiClient.HTTPMethod, headers: [RestApiClient.Headers],
										completionHandler: @escaping RestApiClient.SendResponse<Request.Response>)
}
