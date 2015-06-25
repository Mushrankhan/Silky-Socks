//
//  StatesPickerTableViewCell.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/21/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

// Use of a delegate to provide info for the selected state
protocol StatesPickerTableViewCellDelegate: class {
    func statesPickerTableViewCell(cell: StatesPickerTableViewCell, didSelectState state: String)
}

class StatesPickerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate{
    
    // Delegate
    weak var delegate: StatesPickerTableViewCellDelegate?
    
    @IBOutlet weak var statesPicker: UIPickerView! {
        didSet {
            statesPicker.dataSource = self
            statesPicker.delegate = self
        }
    }
    
    // All the states
    private lazy var states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI","ID","IL IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT, NE","NV","NH","NJ","NM","NY","NC","ND",
        "OH","OK","OR","PA RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    
    // MARK: UIPicker View Data Source
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return states[row]
    }
    
    // MARK: UIPicker View Delegate

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.statesPickerTableViewCell(self, didSelectState: states[row])
    }
    
}
