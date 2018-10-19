//
//  RecipePuppyTests.swift
//  RecipePuppyTests
//
//  Created by Daniel Illescas Romero on 18/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import XCTest
import os
@testable import Recipes

class RecipesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasicAPIResponse() {
		let expectation = XCTestExpectation(description: "Basic api response")
		
		let query = RecipeSearchQuery(title: "", ingredients: "", pageNumber: 1)
		RecipesSearch(query: query).manageRecipes { recipes in
			if !recipes.isEmpty {
				expectation.fulfill()
				os_log("OK: %@", recipes)
			}
		}
		wait(for: [expectation], timeout: 5.0)
    }
	
	func testBasicSimpleQueryResponse() {
		let expectation = XCTestExpectation(description: "Basic recipe search by title")
		
		let query = RecipeSearchQuery(title: "beef", ingredients: "", pageNumber: 1)
		RecipesSearch(query: query).manageRecipes { recipes in
			if recipes.contains(where: { $0.title.lowercased().contains("beef") }) {
				expectation.fulfill()
				os_log("OK: %@", recipes)
			}
		}
		wait(for: [expectation], timeout: 5.0)
	}
	
	func testBasicSimpleIngredientsResponse() {
		let expectation = XCTestExpectation(description: "Search with ingredients")
		
		let query = RecipeSearchQuery(title: "", ingredients: "sugar, honey", pageNumber: 1)
		RecipesSearch(query: query).manageRecipes { recipes in
			if recipes.contains(where: { $0.ingredients.lowercased().contains("sugar") }) {
				expectation.fulfill()
				os_log("OK: %@", recipes)
			}
		}
		wait(for: [expectation], timeout: 5.0)
	}
	
	func testFullResponse() {
		let expectation = XCTestExpectation(description: "Search with ingredients")
		
		let query = RecipeSearchQuery(title: "Beef salad", ingredients: "lettuce", pageNumber: 1)
		RecipesSearch(query: query).manageRecipes { recipes in
			if recipes.contains(where: { $0.title.lowercased().contains("beef") && $0.ingredients.lowercased().contains("lettuce") }) {
				expectation.fulfill()
				os_log("OK: %@", recipes)
			}
		}
		wait(for: [expectation], timeout: 5.0)
	}

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
