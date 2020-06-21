//
//  TaskViewController.swift
//  Planner App
//
//  Created by Boren Wang on 2020/6/19.
//  Copyright © 2020 Boren Wang. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate {

    var currentTask: Task?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtClassName: UITextField!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if currentTask != nil {
            txtTitle.text = currentTask!.title
            txtClassName.text = currentTask!.category

            let formatter = DateFormatter()
            formatter.dateStyle = .short
            if currentTask!.dueDate != nil {
                lblDueDate.text = formatter.string(from: currentTask!.dueDate!)
            }
        }
        
        self.changeEditMode(self)
        
        let textFields: [UITextField] = [txtTitle, txtClassName]
        for tf in textFields {
            tf.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControl.Event.editingDidEnd)
        }
    }
    
    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [txtTitle, txtClassName]
        if sgmtEditMode.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }
            btnChange.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
        else if sgmtEditMode.selectedSegmentIndex == 1{
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            btnChange.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveContact))
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if currentTask == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentTask = Task(context: context)
        }
        currentTask?.title = txtTitle.text
        currentTask?.category = txtClassName.text
        return true
    }
    
    @objc func saveContact() {
        appDelegate.saveContext()
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    
    func dateChanged(date: Date) {
        if currentTask == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentTask = Task(context: context)
        }
        currentTask?.dueDate = date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        lblDueDate.text = formatter.string(from: date)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueDueDate"){
            let dateController = segue.destination as! DateViewController
            dateController.delegate = self
        }
    }

}
