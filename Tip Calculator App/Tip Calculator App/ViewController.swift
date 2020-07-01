// Name: Boren Wang
// SBU-ID: 111385010
//
//  ViewController.swift
//  Tip Calculator App
//
//  Created by Boren Wang on 2020/6/14.
//  Copyright © 2020 Boren Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billAmount: UITextField!
    @IBOutlet weak var btn15: UIButton!
    @IBOutlet weak var btn18: UIButton!
    @IBOutlet weak var btn20: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func btn15Clicked(_ sender: Any) {
        if let total = Double(billAmount.text!) {
            let totalStr = String(format: "%.2f", total+total*0.15)
            let tipStr = String(format: "%.2f", total*0.15)
            label.text = "Tip amount: $\(tipStr) Total: $\(totalStr)"
        }
    }
    
    @IBAction func btn18Clicked(_ sender: Any) {
        if let total = Double(billAmount.text!) {
            let totalStr = String(format: "%.2f", total+total*0.18)
            let tipStr = String(format: "%.2f", total*0.18)
            label.text = "Tip amount: $\(tipStr) Total: $\(totalStr)"
        }
    }
    
    @IBAction func btn20Clicked(_ sender: Any) {
        if let total = Double(billAmount.text!) {
            let totalStr = String(format: "%.2f", total+total*0.20)
            let tipStr = String(format: "%.2f", total*0.20)
            label.text = "Tip amount: $\(tipStr) Total: $\(totalStr)"
        }
    }
}

