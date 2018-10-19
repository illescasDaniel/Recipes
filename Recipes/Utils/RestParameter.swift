//
//  RestParamter.swift
//  RecipePuppy
//
//  Created by Daniel Illescas Romero on 18/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

struct RestParameter<T: CustomStringConvertible> {
	
	let parameter: String
	let value: T
	
	var urlParameter: String {
		return "\(self.parameter)=\(self.value.description.urlFormat ?? "")"
	}
}
