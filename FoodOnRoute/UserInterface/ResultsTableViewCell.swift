//
//  ResultsTableViewCell.swift
//  FoodOnRoute
//
//  Created by Peter Alserda on 15/12/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {
    var productTitle: UILabel = UILabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layoutMargins = UIEdgeInsetsZero
        addProductTitle()
    }

    func addProductTitle() {
        productTitle.frame = CGRectMake(20, 22, self.contentView.bounds.width, 20)
        productTitle.font = UIFont(name: "PT Sans", size: 16)
        productTitle.textColor = foodOnRouteColor.darkBlack
        self.addSubview(productTitle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ProductTableViewCell: ResultsTableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        productTitle.frame = CGRectMake(20, 12.5, self.contentView.bounds.width, 20)
        productTitle.font = UIFont(name: "PT Sans", size: 14)
//        productTitle.backgroundColor = UIColor.blueColor()
    }


    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

