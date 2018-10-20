//
//  RecipeImageViewController.swift
//  Recipes
//
//  Created by Daniel Illescas Romero on 20/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import UIKit

class RecipeImageViewController: UIViewController {
	
	var recipeURL: URL?
	var image: UIImage?
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let imageView = UIImageView(frame: self.view.bounds).apply {
			$0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			$0.contentMode = .scaleAspectFit
			$0.image = self.image
		}
		self.view.insertSubview(imageView, at: 0)
		self.preferredContentSize = CGSize(width: 1000, height: 1000)
	}
}
