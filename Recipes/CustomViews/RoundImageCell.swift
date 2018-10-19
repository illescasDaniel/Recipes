//
//  RoundImageCell.swift
//  RecipePuppy
//
//  Created by Daniel Illescas Romero on 19/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import UIKit

class RoundImageCell: UITableViewCell {
	
	@IBOutlet weak var customContentView: UIView!
	@IBOutlet weak var roundImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	
	override var textLabel: UILabel! {
		return self.titleLabel
	}
	
	override var detailTextLabel: UILabel? {
		return self.detailLabel
	}
	
	override var imageView: UIImageView? {
		return self.roundImageView
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.roundImageView.layer.cornerRadius = self.roundImageView.frame.height / 2
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
