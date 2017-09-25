//
//  BusinessesCell.swift
//  Yelp
//
//  Created by Nader Neyzi on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    var rowNum: Int? = nil

    var business: Business! {
        didSet {
            if let imageURL = business.imageURL {
                thumbImageView.setImageWith(imageURL)
            }
            if let ratingImageURL = business.ratingImageURL {
                ratingImageView.setImageWith(ratingImageURL)
            }
            if let businessName = business.name, let rowNum = rowNum {
                nameLabel.text = String(describing: rowNum) + ". " + businessName
            }
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            if let reviewCount = business.reviewCount {
                reviewCountLabel.text = String(describing: reviewCount) + " Reviews"
            }
            distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
