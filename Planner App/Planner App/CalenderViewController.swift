// Name: Boren Wang
// SBU-ID: 111385010
//
//  CalenderViewController.swift
//  Planner App
//
//  Created by Boren Wang on 2020/6/15.
//  Copyright © 2020 Boren Wang. All rights reserved.
//

import UIKit
import FSCalendar

class CalenderViewController: UIViewController {

    var datesWithEvent = ["2020-01-01"]

    var datesWithMultipleEvents = ["2020-12-31"]

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let dateString = self.dateFormatter.string(from: date)

        if self.datesWithEvent.contains(dateString) {
            return 1
        }

        if self.datesWithMultipleEvents.contains(dateString) {
            return 3
        }

        return 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
