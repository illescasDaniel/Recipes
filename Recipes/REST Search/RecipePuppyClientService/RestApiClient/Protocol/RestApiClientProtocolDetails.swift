//
//  RestApiClientProtocolDetails.swift
//  RestApiClient
//
//  Created by Daniel Illescas Romero on 17/01/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

fileprivate struct BodyStub: RestApiClientBodyRequest {}

extension RestApiClientProtocol {
	
	func fetch<Request: RestApiClientQueryRequest, Body: RestApiClientBodyRequest>(_ request: Request, method: RestApiClient.HTTPMethod,
																			  body: Body, headers: [RestApiClient.Headers] = [],
																			  completionHandler: @escaping RestApiClient.SendResponse<Request.Response>) {
		
		guard let validURL = self.requestToEncodedURL(request) else {
			completionHandler(.error(message: "Error sending request, URL or parameters are not valid.", response: nil, error: nil))
			return
		}
		
		let urlRequest = self.urlRequest(from: validURL, method: method, body: body, headers: headers)
		
		URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, urlResponse, error) in
			if let data = data {
				if type(of: Request.Response.self) != Data.self,
					let response = try? JSONDecoder().decode(Request.Response.self, from: data) {
					completionHandler(.success(response, response: urlResponse))
				} else {
					completionHandler(.dataResponse(data, response: urlResponse))
				}
			} else {
				completionHandler(.error(message: "Error receiving response, no data.", response: urlResponse, error: error))
			}
		}).resume()
	}
	
	func fetch<Request: RestApiClientQueryRequest>(_ request: Request, method: RestApiClient.HTTPMethod = .GET, headers: [RestApiClient.Headers] = [],
											  completionHandler: @escaping RestApiClient.SendResponse<Request.Response>) {
		self.fetch(request, method: method, body: BodyStub(), headers: headers, completionHandler: completionHandler)
	}
	
	// MARK: - Convenience
	
	fileprivate func requestToEncodedURL<Request: RestApiClientQueryRequest>(_ request: Request) -> URL? {
		guard var urlComponents = URLComponents(string: self.baseURL + "/" + request.resourceName + request.extraResourcesPath) else {
			return nil
		}
		urlComponents.queryItems = request.queryDictionary.map { URLQueryItem(name: $0, value: "\($1)") }
		urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
		return urlComponents.url
	}
	
	fileprivate func urlRequest<Body: RestApiClientBodyRequest>(from validURL: URL, method: RestApiClient.HTTPMethod, body: Body, headers: [RestApiClient.Headers]) -> URLRequest {
		var urlRequest = URLRequest(url: validURL)
		urlRequest.httpMethod = "\(method)"
		for header in headers {
			let (key, value) = header.pair
			urlRequest.addValue(value, forHTTPHeaderField: key)
		}
		switch method {
		case .POST, .PUT, .PATCH:
			if let bodyData = try? JSONEncoder().encode(body) {
				urlRequest.httpBody = bodyData
			}
		default: break
		}
		return urlRequest
	}
}

