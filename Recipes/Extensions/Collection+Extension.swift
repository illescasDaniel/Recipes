//
//  Collection.swift
//  RecipePuppy
//
//  Created by Daniel Illescas Romero on 19/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

extension Collection {
	subscript (safe index: Index) -> Element? {
		return self.indices.contains(index) ? self[index] : nil
	}
}
