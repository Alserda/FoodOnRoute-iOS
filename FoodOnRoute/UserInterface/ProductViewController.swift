//
//  ProductsTableViewController.swift
//  FoodOnRoute
//
//  Created by Peter Alserda on 15/12/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit
class ProductViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    let headerViewBackground = UIView()
    let tableView = UITableView()
    let scrollView: UIScrollView = UIScrollView()
    let navigationbarBorder: UIView = UIView()
    var listOfProducts: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.backgroundColor = foodOnRouteColor.darkBlack
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

        setNavigationbarAppearance()

        addScrollView()
        addUpperBackground()


        addTableViewHeader()
        addTableView()
        addBottomBackground()
        addShadowToNavigationbar()
        setScrollViewHeight()
    }
    
    func setScrollViewHeight() {
        let viewsArray = [headerViewBackground, tableView]
        
        var height : CGFloat = 0
        for view in viewsArray {
            for constraint in view.constraints {
                if constraint.identifier == "height" {
                    print(constraint.constant)
                    height += constraint.constant
                }
            }
        }
        
        
        scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, height + 57)
        scrollView.constrainToSize(CGSize(width: self.view.bounds.size.width, height: height + 57))
    }
    
    func addTableViewHeader() {
        headerViewBackground.translatesAutoresizingMaskIntoConstraints = false
        headerViewBackground.backgroundColor = UIColor.whiteColor()
        headerViewBackground.layer.cornerRadius = 5
        
        let title: UILabel = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Producten"
        title.font = UIFont(name: "Montserrat-Bold", size: 21)
        title.textColor = foodOnRouteColor.lightGreen
        headerViewBackground.addSubview(title)
        
        

        
        scrollView.addSubview(headerViewBackground)
        
        headerViewBackground.centerWithTopMarginInView(scrollView, placeUnderViews: nil, topMargin: 25)
        headerViewBackground.constrainToSize(CGSize(width: (self.view.frame.width - 40), height: 66))
        
        title.leftAnchor.constraintEqualToAnchor(headerViewBackground.leftAnchor, constant: 20).active = true
        title.topAnchor.constraintEqualToAnchor(headerViewBackground.topAnchor, constant: 20).active = true
        title.constrainToSize(CGSize(width: (self.view.frame.width - 40), height: 20))
        
    }
    
    
    func addTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.scrollEnabled = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.layer.cornerRadius = 5
        scrollView.addSubview(tableView)
        
        let tableViewHeight: CGFloat = CGFloat(((listOfProducts.count * 47) + listOfProducts.count))
        
        tableView.centerWithTopMarginInView(scrollView, placeUnderViews: [headerViewBackground], topMargin: 18)
        tableView.constrainToSize(CGSize(width: (self.view.frame.width - 40), height: tableViewHeight))
    }

    func resetConstraints() {
        scrollView.removeConstraints(scrollView.constraints)
        scrollView.centerWithTopMargin(self, placeUnderViews: nil, topMargin: 0)
        scrollView.constrainToSize(CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
    }
    func addScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = foodOnRouteColor.lightBlue
        scrollView.scrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true
        self.view.addSubview(scrollView)
        
        scrollView.centerWithTopMargin(self, placeUnderViews: nil, topMargin: 0)
        scrollView.constrainToSize(CGSize(width: self.view.bounds.size.width, height: view.frame.height))
//
//        let view1 = UIView()
//        view1.backgroundColor = UIColor.blackColor()
//        view1.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.addSubview(view1)
//        
//        view1.topAnchor.constraintEqualToAnchor(scrollView.topAnchor, constant: 10).active = true
//        view1.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
//        
//        view1.constrainToSize(CGSize(width: 50, height: 50))
    }

    
    func addBottomBackground() {
        let bottomBackground: UIImageView = UIImageView(image: UIImage(named:
            "BottomBackground"))
        bottomBackground.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(bottomBackground)
        
        bottomBackground.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor, constant: 6).active = true
        bottomBackground.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true

        bottomBackground.constrainToSize(CGSize(width: view.frame.width, height: 191))
    }
    
    func addUpperBackground() {
        let upperBackground: UIImageView = UIImageView(image: UIImage(named: "UpperBackground"))
        upperBackground.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(upperBackground)

        upperBackground.topAnchor.constraintEqualToAnchor(scrollView.topAnchor, constant: 6).active = true
        upperBackground.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
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
        var numberOfRows: Int = 0
        
        if !listOfProducts.isEmpty {
            numberOfRows = listOfProducts.count
        }
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 47
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        if !listOfProducts.isEmpty {
            cell.textLabel?.text = listOfProducts[indexPath.row]
        }
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
            addShadowToNavigationbar()
            resetConstraints()
    }
}
