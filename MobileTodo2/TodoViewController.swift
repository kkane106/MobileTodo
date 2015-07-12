//
//  ViewController.swift
//  TodoMobile
//
//  Created by Kristopher Kane on 7/11/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class TodoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TodoDelegate {
    
    var todoArray = [String]()
    let cellID = "cellID"
    
    @IBOutlet weak var todoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
        
        todoTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        Alamofire.request(.GET, "http://swift-sushi-json.herokuapp.com/sushi.json").responseJSON() {
            (_, _, data, _) in
            let json = JSON(data!)
            if let todo = json["sushi"].arrayObject {
                for i in todo {
                    self.todoArray.append(String(i as! NSString))
                }
            }
            self.todoTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! UITableViewCell
        cell.textLabel?.text = "\(todoArray[indexPath.row])"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    func addTodo(newTodo: String) {
        todoArray.append(newTodo)
        println("before: \(todoArray)")
        todoTableView.reloadData()
        println("after: \(todoArray)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAddTodo" {
            let navController = segue.destinationViewController as! UINavigationController
            let destinationVC = navController.viewControllers[0] as! AddTodoModalViewController
            destinationVC.todoDelegate = self
        }
    }
}
