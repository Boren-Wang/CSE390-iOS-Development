//
//  TasksForClassTableViewController.swift
//  Planner App
//
//  Created by Boren Wang on 2020/6/20.
//  Copyright © 2020 Boren Wang. All rights reserved.
//

import UIKit
import CoreData

class TasksForClassTableViewController: UITableViewController {
    
    var tasks:[NSManagedObject] = []
    var selectedClass:String = ""
    var tasksForClass:[Task] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.rightBarButtonItem = self.editButtonItem

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDatabase()
        tableView.reloadData()
    }

    func loadDataFromDatabase() {
        tasksForClass = []
        let settings = UserDefaults.standard
        var sortField = settings.string(forKey: Constants.sortField)
        switch sortField {
        case "Title":
            sortField = "title"
        case "Class Name":
            sortField = "category"
        case "Due Date":
            sortField = "dueDate"
        default:
            sortField = "title"
        }
        let sortAscending = settings.bool(forKey: Constants.sortDirectionAscending)
        //Set up Core Data Context
        let context = appDelegate.persistentContainer.viewContext
        //Set up Request
        let request = NSFetchRequest<NSManagedObject>(entityName: "Task")
        //Specify sorting
        let sortDescriptor = NSSortDescriptor(key: sortField, ascending: sortAscending)
        let sortDescriptorArray = [sortDescriptor]
        //to sort by multiple fields, add more sort descriptors to the array
        request.sortDescriptors = sortDescriptorArray
        do {
            tasks = try context.fetch(request)
            for t in tasks {
                let task = t as? Task
                let className = task?.category
                if className != nil {
                    if className == selectedClass {
                        tasksForClass.append(task!)
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
        return tasksForClass.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! CustomTableViewCell

        // Configure the cell...
        let task = tasksForClass[indexPath.row]
        cell.title?.text = task.title
        cell.subtitle?.text = task.category
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let date = dateFormatter.string(for: task.dueDate)
        dateFormatter.dateFormat = "EEE"
        let day = dateFormatter.string(for: task.dueDate)
        
        cell.date?.text = date
        cell.day?.text = day
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = tasksForClass[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TaskController") as? TaskViewController
        controller?.currentTask = selectedTask
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let task = tasksForClass[indexPath.row]
            let context = appDelegate.persistentContainer.viewContext
            context.delete(task)
            do {
                try context.save()
            }
            catch  {
                fatalError("Error saving context: \(error)")
            }
            loadDataFromDatabase()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array,
            // and add a new row to the table view
        }
    }

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

}
