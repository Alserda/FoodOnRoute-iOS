//
//  ProductsTableViewController.swift
//  FoodOnRoute
//
//  Created by Peter Alserda on 15/12/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit

class ProductViewController : UIViewController {
    let tableView = UITableView()
    let bottomBackground: UIImageView = UIImageView(image: UIImage(named: "BottomBackground"))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = foodOnRouteColor.lightBlue
        setNavigationbarAppearance()
        addShadowToNavigationbar()
        addUpperBackground()
        addBottomBackground()
    }
    
    func addBottomBackground() {
        bottomBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBackground)
        
        bottomBackground.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor, constant: 0).active = true
        bottomBackground.constrainToSize(CGSize(width: view.frame.width, height: 191))
    }
    
    func addUpperBackground() {
        let upperBackground: UIImageView = UIImageView(image: UIImage(named: "UpperBackground"))
        upperBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(upperBackground)
        
        upperBackground.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor, constant: 6).active = true
        upperBackground.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor, constant: 0).active = true
    
        
        upperBackground.constrainToSize(CGSize(width: 248, height: 88))
    }
    
    
    func setNavigationbarAppearance() {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        self.navigationController?.navigationBar.barTintColor = foodOnRouteColor.lightGreen
        let image = UIImage(named: "BarButtonItem")!.imageWithRenderingMode(.AlwaysOriginal)
        let button = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Done, target: self, action: "goBack:")
        self.navigationItem.leftBarButtonItem = button
    }
    
    func goBack(sender: UIBarButtonItem) {
        print("pressed")
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func addShadowToNavigationbar() {
        let navBorder: UIView = UIView()
        navBorder.backgroundColor = foodOnRouteColor.shadowGreen
        navBorder.opaque = true
        navBorder.translatesAutoresizingMaskIntoConstraints = false
        self.navigationController?.navigationBar.addSubview(navBorder)
        
        navBorder.topAnchor.constraintEqualToAnchor(self.navigationController?.navigationBar.bottomAnchor, constant: 0).active = true
        
        navBorder.constrainToSize(CGSize(width: view.frame.width, height: 3))
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
            /* Resets the border under the navigationBar, otherwise the width of the border will stay the same as it was in portrait mode */
            self.bottomBackground.removeConstraints(self.bottomBackground.constraints)
            addShadowToNavigationbar()
            addBottomBackground()
    }
}
