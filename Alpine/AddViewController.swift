//
//  AddViewController.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    private var cities: [City]!
    private var requestNum = 0
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cities = [City]()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        textField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: IBActions
    
    @IBAction func backButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let city = cities[indexPath.row]
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CityCell")
        cell.textLabel?.text = city.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    // MARK: UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let city = cities[indexPath.row]
        LocationManager.sharedManager.getCoordinatesFromPlace(city.placeId) { (coordinate) -> Void in
            let defaults = NSUserDefaults.standardUserDefaults()
            var forecasts = defaults.stringArrayForKey("Forecasts")!
            forecasts.append("\(coordinate.latitude),\(coordinate.longitude)")
            defaults.setObject(forecasts, forKey: "Forecasts")
            defaults.synchronize()
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: UITextFieldDelegate Methods
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        requestNum += 1
        let request = requestNum
        
        LocationManager.sharedManager.autocompleteSearchTerm(textField.text!) { (results) -> Void in
            guard self.requestNum == request else {
                return
            }
            
            self.cities = results
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        
        return true
    }
}
