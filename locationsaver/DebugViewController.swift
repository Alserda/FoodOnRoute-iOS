//
//  DebugViewController.swift
//  locationsaver
//
//  Created by Peter Alserda on 04/10/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit

class DebugViewController : UITableViewController {
    let locationManager = LocationController()
    var timer : NSTimer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
