//
//  RestApiSendResponse.swift
//  RestApiClient
//
//  Created by Daniel Illescas Romero on 16/01/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

extension RestApiClient {
	typealias ResponseCallback<Response> = (Response) -> Void
	typealias SendResponse<Response> = ResponseCallback<ResponseType<Response>>
	enum ResponseType<T> {
		case success(T, response: URLResponse?)
		case dataResponse(Data, response: URLResponse?)
		case error(message: String, response: URLResponse?, error: Error?)
	}
}
