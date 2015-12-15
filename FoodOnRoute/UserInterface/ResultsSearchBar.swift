//
//  SearchBar.swift
//  FoodOnRoute
//
//  Created by Peter Alserda on 09/12/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit

class ResultsSearchBar : UISearchBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundImage = UIImage()
        self.tintColor = foodOnRouteColor.lightGrey
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(UIImage(named: "searchMagnifier"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal);
        print(self.frame.width)
        
        let searchTextField : UITextField = self.valueForKey("searchField") as! UITextField
//        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.textColor = foodOnRouteColor.lightGrey
        searchTextField.font = UIFont(name: "PT Sans", size: 16)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Wat wil je eten?", attributes: [NSForegroundColorAttributeName: foodOnRouteColor.lightGrey])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}