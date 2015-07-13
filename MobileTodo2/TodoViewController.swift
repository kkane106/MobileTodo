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
import ObjectMapper

class TodoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TodoDelegate {
    
    var todoArray = [Todo]()
    let cellID = "cellID"
    
    @IBOutlet weak var todoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
        
        todoTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        getTodoUpdates()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! UITableViewCell
        cell.textLabel?.text = "\(todoArray[indexPath.row].todoText!)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    func addTodo(newTodo: Todo) {
        todoArray.append(newTodo)
        todoTableView.reloadData()
    }
    @IBAction func doRefreshTodos(sender: UIBarButtonItem) {
        todoArray = []
        getTodoUpdates()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAddTodo" {
            let navController = segue.destinationViewController as! UINavigationController
            let destinationVC = navController.viewControllers[0] as! AddTodoModalViewController
            destinationVC.todoDelegate = self
        }
    }
    
    func getTodoUpdates() {
        Alamofire.request(.GET, "http://swift-sushi-json.herokuapp.com/todos.json").responseJSON() {
            (request, response, responseObject, error) in


//            println("request: \(request)")
            println("responseObject: \(responseObject)")
            let json = JSON(responseObject!)
            if let todo = json["todos"].arrayObject {
                for i in todo {
                    let todoMap = Mapper<Todo>().map(i)
                    self.todoArray.append(todoMap!)
                }
            }
//            println("responseObject: \(json)")
//            println("error: \(error)")
//            println("array: \(self.todoArray)")
            self.todoTableView.reloadData()
        }
    }
    
    func postTodoUpdates() {
    var parameters: [String: AnyObject] = ["todos": "success"]
        Alamofire.request(.POST, "http://swift-sushi-json.herokuapp.com/login", parameters: parameters, encoding: .JSON).responseJSON {
            (request, response, responseObject, error) -> Void in

            println("request: \(request)")
            println("response: \(response)")
            let json = JSON(responseObject!)
            if let todo = json["todos"].string {
                println("TODO:\(todo)")
            }
            println("responseObject: \(responseObject)")
            println("error: \(error)")
        }
    }
    
}
