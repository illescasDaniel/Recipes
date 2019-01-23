//
//  RestApiHeaders.swift
//  RestApiClient
//
//  Created by Daniel Illescas Romero on 16/01/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

extension RestApiClient {
	enum Headers {
		case contentType(MIMEType)
		case accept(MIMEType)
		
		enum MIMEType {
			
			case applicationJSON
			case applicationJSONIn(Charsets)
			// TODO: add more MIMETypes
			case any
			
			enum Charsets: String {
				case utf8 = "utf-8"
				// TODO: add more charsets
			}
		}
	}
}

//

extension RestApiClient.Headers {
	var pair: (key: String, value: String) {
		switch self {
		case .contentType(let mimeType):
			return (key: "Content-Type", value: mimeType.rawValue)
		case .accept(let mimeType):
			return (key: "Accept", value: mimeType.rawValue)
		}
		// ...
	}
}

extension RestApiClient.Headers.MIMEType {
	var rawValue: String {
		switch self {
		case .applicationJSON:
			return "application/json"
		case .applicationJSONIn(let charset):
			return RestApiClient.Headers.MIMEType.applicationJSON.rawValue + charset.value
		// ...
		case .any:
			return "*/*"
		}
	}
}

extension RestApiClient.Headers.MIMEType.Charsets {
	var value: String {
		return "; charset=" + self.rawValue
	}
}



