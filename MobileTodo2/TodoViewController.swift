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
    var response = String()
    
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            deleteTodo(todoArray[indexPath.row])
            todoArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func addTodo(newTodo: Todo) {
        todoArray.append(newTodo)
        todoTableView.reloadData()
    }
    
    func deleteTodo(deleteTodo: Todo) {
        postDeleteTodo(deleteTodo.todoID!)
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
        Alamofire.request(
                            .GET,
                            "http://swift-sushi-json.herokuapp.com/todos.json"
                            ).responseJSON() {
            (request, response, responseObject, error) in
            let json = JSON(responseObject!)
            if let todo = json["todos"].arrayObject {
                for i in todo {
                    let todoMap = Mapper<Todo>().map(i)
                    self.todoArray.append(todoMap!)
                }
            } else {
                println("ERROR")
            }
            self.todoTableView.reloadData()
        }
    }
    
    func postTodoUpdates(newTodo: String) {
        var parameters: [String: String] = ["todos": newTodo]
        Alamofire.request(
                            .POST,
                            "http://swift-sushi-json.herokuapp.com/create_todo",
                            parameters: parameters,
                            encoding: .JSON).responseJSON {
            (request, response, responseObject, error) -> Void in
            if let responseObject: AnyObject = responseObject {
                let json = JSON(responseObject)
                if let todo = json["todo"].arrayObject {
                    for i in todo {
                        let todoMap = Mapper<Todo>().map(i)
                        self.todoArray.append(todoMap!)
                    }
                }
            } else {
                println("ERROR")
            }
            self.todoTableView.reloadData()
        }
    }
    
    func postDeleteTodo(deleteTodo: Int) {
        let parameters: [String: Int] = ["todos": deleteTodo]
        Alamofire.request(
                            .POST,
                            "http://swift-sushi-json.herokuapp.com/delete_todo",
                            parameters: parameters,
                            encoding: .JSON
                            ).responseJSON {
                                
            (request, response, responseObject, error) -> Void in
            if let responseObject: AnyObject = responseObject {
                let json = JSON(responseObject)
                if let todo = json["todo"].string {
                    println(todo)
                }
            } else {
                println("ERROR")
            }
        }
    }
    
    func createErrorLabel() {
        let errorLabel = UILabel()
        errorLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
    }
    
}
