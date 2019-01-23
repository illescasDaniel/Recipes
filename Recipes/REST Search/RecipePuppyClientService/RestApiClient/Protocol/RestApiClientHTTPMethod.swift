//
//  RestApiHTTPMethod.swift
//  RestApiClient
//
//  Created by Daniel Illescas Romero on 16/01/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

extension RestApiClient {
	enum HTTPMethod {
		case GET
		case POST
		case PUT
		case PATCH
		case DELETE
		
		case COPY
		case HEAD
		case OPTIONS
		case LINK
		case UNLINK
		case PURGE
		case LOCK
		case UNLOCK
		case PROPFIND
		case VIEW
	}
}
