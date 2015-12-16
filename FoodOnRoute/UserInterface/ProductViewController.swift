//
//  ProductsTableViewController.swift
//  FoodOnRoute
//
//  Created by Peter Alserda on 15/12/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit

class ProductViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    let bottomBackground: UIImageView = UIImageView(image: UIImage(named:
        "BottomBackground"))
    let navigationbarBorder: UIView = UIView()
    var listOfProducts: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.backgroundColor = foodOnRouteColor.lightBlue
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

        setNavigationbarAppearance()
        addShadowToNavigationbar()
        
        addUpperBackground()
        addBottomBackground()
        addTableView()
        print(listOfProducts)
    }
    
    func addTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.layer.cornerRadius = 5
        view.addSubview(tableView)
        
        tableView.centerWithTopMargin(self, placeUnderViews: nil, topMargin: 20)
        tableView.constrainToSize(CGSize(width: (self.view.frame.width - 40), height: 400))
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
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = foodOnRouteColor.lightGreen
        let image = UIImage(named: "BarButtonItem")!.imageWithRenderingMode(.AlwaysOriginal)
        let button = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Done, target: self, action: "goBack:")
        self.navigationItem.leftBarButtonItem = button
        
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "FoodOnRouteLogo")
        
        self.navigationItem.titleView = imageView
    }
    
    func goBack(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func addShadowToNavigationbar() {
        if !navigationbarBorder.constraints.isEmpty {
            navigationbarBorder.removeConstraints(navigationbarBorder.constraints)
        }
        navigationbarBorder.backgroundColor = foodOnRouteColor.shadowGreen
        navigationbarBorder.opaque = true
        navigationbarBorder.tag = 10
        navigationbarBorder.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationbarBorder)
        
//        navigationbarBorder.topAnchor.constraintEqualToAnchor(self.navigationController?.navigationBar.bottomAnchor, constant: 0).active = true
        navigationbarBorder.constrainToSize(CGSize(width: view.frame.width, height: 3))
    }

    
    
    // MARK: TableView Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 47
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Hallo"
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {

    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
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
