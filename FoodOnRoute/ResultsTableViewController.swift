//
//  ResultsTableViewController.swift
//  FoodOnRoute
//
//  Created by Peter Alserda on 08/12/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit

class ResultsTableViewController : UITableViewController {
    var timer : NSTimer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Debug view"
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "refreshTable", userInfo: nil, repeats: true)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Debugger.messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        cell?.textLabel?.text = Debugger.messages[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFontOfSize(15)
        return cell!
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print ("Nu geselecteerd is: \(indexPath.row)")
    }
    
    func refreshTable() {
        tableView.reloadData()
    }
}