//
//  ProductTableViewCell.swift
//  FoodOnRoute
//
//  Created by Peter Alserda on 10/01/16.
//  Copyright © 2016 Peter Alserda. All rights reserved.
//

import UIKit

class ProductTableViewCell: ResultsTableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        productTitle.frame = CGRectMake(20, 12.5, self.contentView.bounds.width, 20)
        productTitle.font = UIFont(name: "PT Sans", size: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

