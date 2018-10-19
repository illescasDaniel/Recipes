//
//  String+Extensions.swift
//  RecipePuppy
//
//  Created by Daniel Illescas Romero on 18/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

extension String {
	var urlFormat: String? {
		return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
	}
}
