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
    let headerViewTitle = UILabel()
    let tableView = UITableView()
    let bottomBackground: UIImageView = UIImageView(image: UIImage(named:
        "BottomBackground"))
    let scrollView: UIScrollView = UIScrollView()
    let navigationbarBorder: UIView = UIView()
    var listOfProducts: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.backgroundColor = foodOnRouteColor.darkBlack
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
//        listOfProducts = ["Afrikaanse baobab", "boomkalebas", "brave hendrik", "kudzu", "ora", "pijlkruid", "pijpajuin", "rammenas", "schorseneren", "teunisbloem"]
        tableView.registerClass(ProductTableViewCell.self, forCellReuseIdentifier: "ProductCell")

        setNavigationbarAppearance()

        addScrollView()
        addUpperBackground()


        addTableViewHeader()
        addTableView()
//        addBottomBackground()
        addShadowToNavigationbar()
//        setScrollViewHeight()
    }
    
    func setScrollViewHeight() {
        let viewsArray = [headerViewBackground, tableView, bottomBackground]
        
        var height : CGFloat = 0
        for view in viewsArray {
            for constraint in view.constraints {
                if constraint.identifier == "height" {
                    print(constraint.constant)
                    height += constraint.constant
                }
            }
        }
        
        
        scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, height + 139)
        scrollView.constrainToSize(CGSize(width: self.view.bounds.size.width, height: height + 139))
    }
    
    func addTableViewHeader() {
        headerViewBackground.translatesAutoresizingMaskIntoConstraints = false
        headerViewBackground.backgroundColor = UIColor.whiteColor()
        headerViewBackground.layer.cornerRadius = 5
        
        headerViewTitle.translatesAutoresizingMaskIntoConstraints = false
        headerViewTitle.text = "Producten"
        headerViewTitle.font = UIFont(name: "Montserrat-Bold", size: 21)
        headerViewTitle.textColor = foodOnRouteColor.lightGreen
        headerViewBackground.addSubview(headerViewTitle)
        
        

        
        scrollView.addSubview(headerViewBackground)
        
        headerViewBackground.centerWithTopMarginInView(scrollView, placeUnderViews: nil, topMargin: 25)
        headerViewBackground.constrainToSize(CGSize(width: (self.view.frame.width - 40), height: 66))
        
        headerViewTitle.leftAnchor.constraintEqualToAnchor(headerViewBackground.leftAnchor, constant: 20).active = true
        headerViewTitle.topAnchor.constraintEqualToAnchor(headerViewBackground.topAnchor, constant: 24).active = true
        headerViewTitle.constrainToSize(CGSize(width: (self.view.frame.width - 40), height: 20))
        
    }
    
    
    func addTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.scrollEnabled = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.layer.cornerRadius = 5
        
        
        let upperSeparator = UIView(frame: CGRectMake(0, 0, self.view.frame.width - 40, 0.5))
        upperSeparator.backgroundColor = self.tableView.separatorColor
        tableView.addSubview(upperSeparator)
        
        
        scrollView.addSubview(tableView)
        
        let tableViewHeight: CGFloat = CGFloat(((listOfProducts.count * 47) + listOfProducts.count))
        
        tableView.centerWithTopMarginInView(scrollView, placeUnderViews: [headerViewBackground], topMargin: 18)
        tableView.constrainToSize(CGSize(width: (self.view.frame.width - 40), height: tableViewHeight))
    }

    func resetConstraints() {
        scrollView.removeConstraints(scrollView.constraints)
        scrollView.centerWithTopMargin(self, placeUnderViews: nil, topMargin: 0)
        scrollView.constrainToSize(CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        
        tableView.removeConstraints(tableView.constraints)
        let tableViewHeight: CGFloat = CGFloat(((listOfProducts.count * 47) + listOfProducts.count))
        tableView.centerWithTopMarginInView(scrollView, placeUnderViews: [headerViewBackground], topMargin: 18)
        tableView.constrainToSize(CGSize(width: (self.view.frame.width - 40), height: tableViewHeight))
        
        headerViewBackground.removeConstraints(headerViewBackground.constraints)
        headerViewBackground.centerWithTopMarginInView(scrollView, placeUnderViews: nil, topMargin: 25)
        headerViewBackground.constrainToSize(CGSize(width: (self.view.frame.width - 40), height: 66))
        
        headerViewTitle.removeConstraints(headerViewTitle.constraints)
        headerViewTitle.leftAnchor.constraintEqualToAnchor(headerViewBackground.leftAnchor, constant: 20).active = true
        headerViewTitle.topAnchor.constraintEqualToAnchor(headerViewBackground.topAnchor, constant: 24).active = true
        headerViewTitle.constrainToSize(CGSize(width: (self.view.frame.width - 40), height: 20))
        
        
    }
    func addScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = foodOnRouteColor.lightBlue
        scrollView.scrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 2)
        self.view.addSubview(scrollView)
        
        scrollView.centerWithTopMargin(self, placeUnderViews: nil, topMargin: 0)
        scrollView.constrainToSize(CGSize(width: self.view.bounds.size.width, height: view.frame.height))
    }

    
    func addBottomBackground() {
        bottomBackground.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(bottomBackground)
        
        bottomBackground.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor, constant: 0).active = true
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
        navigationbarBorder.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationbarBorder)
    
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
        
        let cell: ProductTableViewCell = tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as! ProductTableViewCell
        
        if !listOfProducts.isEmpty {
            cell.productTitle.text = listOfProducts[indexPath.row]
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
