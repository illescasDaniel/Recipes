//
//  URLRequest+extensions.swift
//  RestApiClient
//
//  Created by Daniel Illescas Romero on 17/01/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

extension URLResponse {
	var statusCodeValue: RestApiClient.StatusCode {
		if let rawStatusCode = (self as? HTTPURLResponse)?.statusCode {
			return RestApiClient.StatusCode(rawStatusCode: rawStatusCode)
		}
		return RestApiClient.StatusCode.unknown
	}
}

extension Optional where Wrapped == URLResponse {
	var statusCodeValue: RestApiClient.StatusCode {
		if let validURLResponse = self {
			return validURLResponse.statusCodeValue
		}
		return .unknown
	}
}
