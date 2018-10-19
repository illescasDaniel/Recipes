//
//  Ingredients.swift
//  RecipePuppy
//
//  Created by Daniel Illescas Romero on 18/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

enum Ingredient: String {
	
	case hotSauce = "hot+sauce"
	case potato
	case cornstarch
	case thyme
	case oliveOil = "olive+oil"
	case milk
	case pecan
	case mayonnaise
	case broccoli
	case rice
	case vegetableOil = "vegetable+oil"
	case greenOnion = "green+onion"
	case parmesanCheese = "parmesan+cheese"
	case breadCrums = "bread+crumbs"
	case carrot
	case redOnions = "red+onions"
	case bacon
	case eggs
	case cheddarCheese = "cheddar+cheese"
	case honey
	case almonds
	case chickenBroth = "chicken+broth"
	case limeJuice = "lime+juice"
	case sourCream = "sour+cream"
	case tomato
	case soySauce = "soy+sauce"
	case worcestershireSauce = "worcestershire+sauce"
	case saladDesssing = "salad+dressing"
	case oregano
	case butter
	case garlic
	case salt
	case basil
	case mushroom
	case chicken
	case garlicPowder = "garlic+powder"
	case paprika
	case parsley
	case flour
	case greenPepper = "green+pepper"
	case whiteWine = "white+wine"
	case rosemary
	case onions
	case water
	case lemonJuice = "lemon+juice"
	case cumin
	case sugar
	case celery
	case blackPepper = "black+pepper"
	case redPepper = "red+pepper"
	case curryPowder = "curry+powder"
	
	case nutmeg
	case cilantro
	case redPepperFlakes = "red+pepper+flakes"
	case peas
	case margarine
	case cayenne
	case brownSuger = "brown+sugar"
	case raisins
	case cinnamon
	case riceKrispies = "rice+krispies"
	case groundBeef = "ground+beef"
	case chiliPowder = "chili+powder"
	case vanillaExtract = "vanilla+extract"
	
	case dijonMustard = "dijon+mustard"
	case ketchup
	case beefBouillonGranules = "beef+bouillon+granules"
	case sirloinSteak = "sirloin+steak"
	case chilliPowder = "chilli+powder"
	case cabbage
	case beef
	case redWine = "red+wine"
	case beer
	case mustardPowder = "mustard+powder"
	case ginger
	case bayLeaf = "bay-leaf"
	case bayLeaves = "bay-leaves"
	
	case vinegar
	case serranoPepper = "serrano+pepper"
	case avocado
	case balsamicVinegar = "balsamic+vinegar"
	case whiteVinegar = "white+vinegar"
	case greenChilies = "green+chilies"
	case peach
	case chilies
	case cucumber
	case tortillaChips = "tortilla+chips"
	case yellowBellPepper = "yellow+bell+pepper"
	case seaSalt = "sea+salt"
	case habaneroPepper = "habanero+pepper"
	case pineapple
	case kosherSalt = "kosher+salt"
	
	case romaTomato = "roma+tomato"
	case corn
	case orangeJuice = "orange+juice"
	case tomatillo
	case jalapeno
	case redWineCinegar = "red+wine+vinegar"
	case blackBeans = "black+beans"
	case mango
	case salsa
	
	case bakingPowder = "baking+powder"
	case mozzarellaCheese = "mozzarella+cheese"
	case sausage
	case skimMilk = "skim+milk"
	case strawberries
	case cheese
	case blueberries
	case hashBrowns = "hash+browns"
	case bakingSoda = "baking+soda"
	case creamCheese = "cream+cheese"
	case yogurt
	case banana
	case ham
	case bread
	case montereyJackCheese = "monterey+jack+cheese"
	case halfAndHalf = "half+and+half"
	case apple
	case breakfastSausage = "breakfast+sausage"
	case oats
	case flourTortillas = "flour+tortillas"
	
	// TODO: complete!!
	
	case unknown
	
	var name: String {
		return self.rawValue.replacingOccurrences(of: "+", with: " ").capitalized
	}
}
