//
//  RestApiClientStatusCodes.swift
//  RestApiClient
//
//  Created by Daniel Illescas Romero on 17/01/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

extension RestApiClient {
	enum StatusCode: String {
		
		case info = "1XX"
		
		case success = "2XX"
		case ok = "200"
		case created = "201"
		case accepted = "202"
		case noContent = "204"
		
		case redirection = "3XX"
		case movedPermanently = "301"
		case found = "302"
		case seeOther = "303"
		case notModified = "304"
		case temporaryRedirect = "307"
		
		case clientError = "4XX"
		case badRequest = "400"
		case unauthorized = "401"
		case forbidden = "403"
		case notFound = "404"
		case methodNotAllowed = "405"
		case notAcceptable = "406"
		case preconditionFailed = "412"
		case unsupportedMediaType = "415"
		
		case serverError = "5XX"
		case internalServerError = "500"
		case notImplemented = "501"
		
		case unknown = "?"
		
		init(rawStatusCode: Int) {
			if let statusCode = StatusCode(rawValue: "\(rawStatusCode)") {
				self = statusCode
			}
			else {
				switch rawStatusCode {
				case 100...199:
					self = .info
				case 200...299:
					self = .success
				case 300...399:
					self = .redirection
				case 400...499:
					self = .clientError
				case 500...599:
					self = .serverError
				default:
					self = .unknown;
				}
			}
		}
	}
}

