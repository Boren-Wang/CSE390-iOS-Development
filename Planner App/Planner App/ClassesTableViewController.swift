// Name: Boren Wang
// SBU-ID: 111385010
//
//  ClassesTableViewController.swift
//  Planner App
//
//  Created by Boren Wang on 2020/6/20.
//  Copyright © 2020 Boren Wang. All rights reserved.
//

// I got the idea from the textbook
import UIKit
import CoreData

class ClassesTableViewController: UITableViewController {
    
    var tasks:[NSManagedObject] = []
    var classes:[String] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDatabase()
        tableView.reloadData()
    }

    func loadDataFromDatabase() {
        classes = []
        //Set up Core Data Context
        let context = appDelegate.persistentContainer.viewContext
        //Set up Request
        let request = NSFetchRequest<NSManagedObject>(entityName: "Task")
        do {
            tasks = try context.fetch(request)
            for t in tasks {
                let task = t as? Task
                let className = task?.category
                if className != nil {
                    if !classes.contains(className!) { // if the className is not in the classes
                        classes.append(className!)
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return classes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath) as! ClassTableViewCell

        // Configure the cell...
        let c = classes[indexPath.row]
        cell.name.text = c
        cell.color.text = String(getTasksForClass(c).count)
        cell.color.backgroundColor = getColor(c)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedClass = classes[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TasksForClassTableViewController") as? TasksForClassTableViewController
        controller?.selectedClass = selectedClass
//        controller?.tasksForClass = getTasksForClass(selectedClass)
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Helper Functions
    func getColor(_ className: String) -> UIColor {
        var color = UIColor.black
        let date = Date()
        let tasksForClass = getTasksForClass(className)
        for task in tasksForClass {
            if task.dueDate != nil {
                if getDaysBetweenDates(firstDate: date, secondDate: task.dueDate!) == 0 {
                    color = UIColor.red
                } else if getDaysBetweenDates(firstDate: date, secondDate: task.dueDate!) == 1 && color != UIColor.red {
                    color = UIColor.blue
                }
            }
        }
        return color
    }
    
    func getTasksForClass(_ className: String) -> [Task] {
        var tasksForClass:[Task] = []
        for t in tasks {
            let task = t as? Task
            let category = task?.category
            if category != nil {
                if category==className { // if the className is not in the classes
                    tasksForClass.append(task!)
                }
            }
        }
        return tasksForClass
    }
    
    func getDaysBetweenDates(firstDate: Date, secondDate: Date) -> Int {
        let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day!
    }
}
