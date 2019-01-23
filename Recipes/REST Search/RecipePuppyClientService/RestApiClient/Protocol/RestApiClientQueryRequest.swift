//
//  RestApiRequest.swift
//  RestApiClient
//
//  Created by Daniel Illescas Romero on 16/01/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

protocol RestApiClientQueryRequest {
	associatedtype Response: Decodable
	var resourceName: String { get }
	var extraResourcesPath: String { get }
	var queryDictionary: [String: Encodable] { get }
}

extension RestApiClientQueryRequest {
	var extraResourcesPath: String {
		return ""
	}
}

protocol RestApiClientBodyRequest: Encodable {}
