//
//  ApplyProtocol.swift
//  Recipes
//
//  Created by Daniel Illescas Romero on 20/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

protocol ApplyProtocol { }
extension ApplyProtocol {
	@discardableResult
	func apply(closure: (Self) -> ()) -> Self {
		closure(self)
		return self
	}
}
