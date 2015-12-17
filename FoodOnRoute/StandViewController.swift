//
//  StandViewController.swift
//  FoodOnRoute
//
//  Created by Stefan Brouwer on 17-12-15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit
import RealmSwift

class StandViewController : UIViewController {
    let upperBackground: UIImageView = UIImageView(image: UIImage(named: "UpperBackground"))
    let bottomBackground: UIImageView = UIImageView(image: UIImage(named:
        "BottomBackground"))
    let standImage: UIImageView = UIImageView(image: UIImage(named: "BottomBackground"))
    var scrollView: UIScrollView = UIScrollView()
    let navigationbarBorder: UIView = UIView()

    var stand: Stand = Stand()
    let realm = try! Realm()

    let standContainer: UIView = UIView()
    let standTitle: UILabel = UILabel()
    let standDescription: UILabel = UILabel()
    var stand: Stand = Stand()

    let productsContainer: UIView = UIView()
    let productsTitle: UILabel = UILabel()
    let productsButton: UIButton = UIButton(type: UIButtonType.System) as UIButton

    override func viewDidLoad() {
        super.viewDidLoad()
        stand = realm.objects(Stand).first!
        print(stand)

        self.view.backgroundColor = foodOnRouteColor.darkBlack
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        setNavigationbarAppearance()
        addScrollView()
        addStandText()
        addUpperBackground()
        addBottomBackground()
        addShadowToNavigationbar()

        addProductsSection()

//        setScrollViewHeight()
    }

    func addProductsSection() {
        productsContainer.translatesAutoresizingMaskIntoConstraints = false
        productsContainer.backgroundColor = UIColor.whiteColor()
        productsContainer.layer.cornerRadius = 5

        productsTitle.translatesAutoresizingMaskIntoConstraints = false
        productsTitle.text = "Producten"
        productsTitle.font = UIFont(name: "Montserrat-Bold", size: 21)
        productsTitle.textColor = foodOnRouteColor.lightGreen
        productsContainer.addSubview(productsTitle)


        productsButton.translatesAutoresizingMaskIntoConstraints = false
        productsButton.backgroundColor = foodOnRouteColor.lightGreen
        productsButton.layer.cornerRadius = 5
//        productsButton.setImage(UIImage(named: "NavToStandButton")?.imageWithRenderingMode(.AlwaysOriginal), forState: UIControlState.Normal)
        productsButton.setTitle("Alle producten", forState: .Normal)
        productsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        productsButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)!
        productsButton.addTarget(self, action: "openProductView:", forControlEvents: UIControlEvents.TouchUpInside)
        productsContainer.addSubview(productsButton)

        scrollView.addSubview(productsContainer)


        productsContainer.centerWithTopMarginInView(scrollView, placeUnderViews: nil, topMargin: 25)
        productsContainer.constrainToSize(CGSize(width: (self.view.frame.width - 40), height: 260))

        productsTitle.leftAnchor.constraintEqualToAnchor(productsContainer.leftAnchor, constant: 20).active = true
        productsTitle.topAnchor.constraintEqualToAnchor(productsContainer.topAnchor, constant: 24).active = true
        productsTitle.constrainToSize(CGSize(width: (self.view.frame.width - 80), height: 20))




        productsButton.bottomAnchor.constraintEqualToAnchor(productsContainer.bottomAnchor, constant: -20).active = true
        productsButton.leftAnchor.constraintEqualToAnchor(productsContainer.leftAnchor, constant: 20).active = true
        print(productsContainer.bounds.width)
        productsButton.constrainToSize(CGSize(width: (self.view.frame.width - 80), height: 47))
    }


    func setScrollViewHeight() {
        let viewsArray = [bottomBackground]

        var height : CGFloat = 0
        for view in viewsArray {
            for constraint in view.constraints {
                if constraint.identifier == "height" {
                    height += constraint.constant
                }
            }
        }

        scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, height + 139)
    }

    func addStandImage() {

    }

    func addStandText() {
        standContainer.translatesAutoresizingMaskIntoConstraints = false
        standContainer.backgroundColor = UIColor.whiteColor()
        standContainer.layer.cornerRadius = 5

        standTitle.translatesAutoresizingMaskIntoConstraints = false
        standTitle.text = "Standnaam"
        standTitle.font = UIFont(name: "Montserrat-Bold", size: 21)
        standTitle.textAlignment = .Left
        standTitle.textColor = foodOnRouteColor.lightGreen

        standDescription.translatesAutoresizingMaskIntoConstraints = false
        standDescription.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        standDescription.font = UIFont(name: "PT Sans", size: 14)
        standDescription.textAlignment = .Left
        standDescription.backgroundColor = UIColor.blueColor()

        scrollView.addSubview(standContainer)
        scrollView.addSubview(standTitle)
        scrollView.addSubview(standDescription)


        standContainer.centerWithTopMarginInView(scrollView, placeUnderViews: nil, topMargin: 25)
        standContainer.constrainToSize(CGSize(width: (self.view.frame.width - 40), height: 300))
        standTitle.leftAnchor.constraintEqualToAnchor(standContainer.leftAnchor, constant: 20).active = true
        standTitle.topAnchor.constraintEqualToAnchor(standContainer.topAnchor, constant: 24).active = true
        standDescription.topAnchor.constraintEqualToAnchor(standTitle.bottomAnchor, constant: 24).active = true
        standDescription.leftAnchor.constraintEqualToAnchor(standContainer.leftAnchor, constant: 20).active = true

        standDescription.constrainToSize(CGSize(width: self.view.bounds.width - 80, height: 200))
    }

    func addScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = foodOnRouteColor.lightBlue
        scrollView.scrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        self.view.addSubview(scrollView)

        scrollView.centerWithTopMargin(self, placeUnderViews: nil, topMargin: 0)
        scrollView.constrainToSize(CGSize(width: self.view.bounds.size.width, height: view.frame.height))
    }


    func addBottomBackground() {
        bottomBackground.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(bottomBackground)
        bottomBackground.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor, constant: 0).active = true
        bottomBackground.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true


        bottomBackground.constrainToSize(CGSize(width: view.frame.width, height: 191))
    }

    func addUpperBackground() {
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

    func openProductView(sender: UIButton) {
        let productVC = ProductViewController()

        var products: [String] = [String]()
        for product in stand.products {
            products.append(product.name)
        }

        productVC.listOfProducts = products
        self.navigationController?.pushViewController(productVC, animated: true)

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

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        /* Resets the border under the navigationBar, otherwise the width of the border will stay the same as it was in portrait mode */
        addShadowToNavigationbar()
    }
}