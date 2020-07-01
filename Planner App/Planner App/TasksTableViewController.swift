// Name: Boren Wang
// SBU-ID: 111385010
//
//  FirstViewController.swift
//  Planner App
//
//  Created by Boren Wang on 2020/6/15.
//  Copyright © 2020 Boren Wang. All rights reserved.
//

// I got the idea from the textbook
import UIKit
import CoreData
import UserNotifications

class TasksTableViewController: UITableViewController {

    var tasks:[NSManagedObject] = []
    var isHiding:Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var lblToday: UILabel!
    @IBOutlet weak var hideTasksPastDue: UIButton!
    
    @IBAction func hideTasksPastDueClicked(_ sender: UIButton) {
//        print("isHiding: \(isHiding)")
        if(isHiding) { // will unhide the tasks past due
            loadDataFromDatabase()
            tableView.reloadData()
            sender.setTitle(" Hide Tasks Past Due ", for: .normal)
            isHiding = false
        } else { // will hide the tasks past due
            let today:Date = Date()
            for t in tasks {
                let index = tasks.firstIndex(of: t)
                let task = t as? Task
                let dueDate = task?.dueDate
                if dueDate != nil {
                    if getDaysBetweenDates(firstDate: dueDate!, secondDate: today)>0 { // today-dueDate > 0
                        tasks.remove(at: index!)
                    }
                }
            }
            tableView.reloadData()
            sender.setTitle(" Show Tasks Past Due ", for: .normal)
            isHiding = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let today_date = dateFormatter.string(for: Date())
        dateFormatter.dateFormat = "EEE"
        let today_day = dateFormatter.string(for: Date())
        lblToday.text = "\(today_day!) \(today_date!)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDatabase()
        tableView.reloadData()
        isHiding = false
        hideTasksPastDue.setTitle(" Hide Tasks Past Due ", for: .normal)
        
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in
            if error != nil {
                // success!
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = getNumberOfTasksNotYetDue()
    }
    
    func loadDataFromDatabase() {
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
//            print("load successfully!")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! CustomTableViewCell
        
        // Configure the cell...
//        print("configuring the cell")
        let task = tasks[indexPath.row] as? Task
        cell.title?.text = task?.title
        cell.subtitle?.text = task?.category
        
        if task?.dueDate == nil {
            cell.date?.text = "XX/XX"
            cell.day?.text = "Xxx"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            let date = dateFormatter.string(for: task?.dueDate)
            dateFormatter.dateFormat = "EEE"
            let day = dateFormatter.string(for: task?.dueDate)
            cell.date?.text = date
            cell.day?.text = day
        }
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.row] as? Task
//        let name = selectedTask!.title!
//        let actionHandler = { (action:UIAlertAction!) -> Void in
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "TaskController")
//                as? TaskViewController
//            controller?.currentTask = selectedTask
//            self.navigationController?.pushViewController(controller!, animated: true)
//        }
//
//        let alertController = UIAlertController(title: "Task selected",
//                                                message:  "Selected row: \(indexPath.row) (\(name))",
//            preferredStyle: .alert)
//
//        let actionCancel = UIAlertAction(title: "Cancel",
//                                         style: .cancel,
//                                         handler: nil)
//        let actionDetails = UIAlertAction(title: "Show Details",
//                                          style: .default,
//                                          handler: actionHandler)
//        alertController.addAction(actionCancel)
//        alertController.addAction(actionDetails)
//        present(alertController, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TaskController") as? TaskViewController
        controller?.currentTask = selectedTask
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let task = tasks[indexPath.row] as? Task
            let context = appDelegate.persistentContainer.viewContext
            context.delete(task!)
            do {
                try context.save()
            }
            catch  {
                fatalError("Error saving context: \(error)")
            }
            loadDataFromDatabase()
            tableView.deleteRows(at: [indexPath], with: .fade)
            UIApplication.shared.applicationIconBadgeNumber = getNumberOfTasksNotYetDue()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array,
            // and add a new row to the table view
        }
    }
    
    /*
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditTask" {
            let taskController = segue.destination as? TaskViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let selectedTask = tasks[selectedRow!] as? Task
            taskController?.currentTask = selectedTask!
        }
    }
    */
    
    // MARK: - Helper Functions
    func getDaysBetweenDates(firstDate: Date, secondDate: Date) -> Int {
        let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day!
    }
    
    func getNumberOfTasksNotYetDue() -> Int{
        var num:Int = 0
        let today:Date = Date()
        for t in tasks {
            let task = t as? Task
            let dueDate = task?.dueDate
            if dueDate != nil {
                if getDaysBetweenDates(firstDate: today, secondDate: dueDate!)>=0 { // dueDate-today >= 0
                    num+=1
                }
            }
        }
        return num
    }
}

