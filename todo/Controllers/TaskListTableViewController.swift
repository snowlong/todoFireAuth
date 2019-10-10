//
//  TaskListTableViewController.swift
//  todo
//
//  Created by Jun Takahashi on 2019/05/22.
//  Copyright © 2019年 Jun Takahashi. All rights reserved.
//

import UIKit
import FirebaseAuth

class TaskListTableViewController: UITableViewController, TaskCollectionDelegate {
    
    let taskCollection = TaskCollection.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        taskCollection.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addTappedBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "showToAddViewController", sender: nil)
    }
    
    @IBAction func logoutTappedBtn(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            let appDelegate = AppDelegate.shared
            appDelegate.window?.rootViewController = loginVC
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

}

extension TaskListTableViewController {
    // デリゲート
    func reload() {
        print ("saved")
        self.tableView.reloadData()
    }
}

extension TaskListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskCollection.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print ("Section: " + String(indexPath.section) + " row:" + String(indexPath.row))
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        
        cell.textLabel?.text = taskCollection.tasks[indexPath.row].title
        
        return cell
    }
    
    // セルの選択
    override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let addVC = storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        addVC.selectedTask = taskCollection.tasks[indexPath.row]
        self.navigationController?.pushViewController(addVC, animated: true)
        //        performSegue(withIdentifier: "showToTaskViewController", sender: selectedTask)
    }
    
    // スワイプで削除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        taskCollection.removeTask(at: indexPath.row)
    }
    
}
