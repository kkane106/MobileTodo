//
//  AddTodoModalViewController.swift
//  TodoMobile
//
//  Created by Kristopher Kane on 7/11/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit

protocol TodoDelegate {
    func addTodo(newTodo: Todo)
    func postTodoUpdates(newTodo: String)
    func deleteTodo(deleteTodo: Todo)
}

class AddTodoModalViewController: UIViewController {
    
    var todoDelegate: TodoDelegate?
    
    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var addTodoBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBarButton.target = self
        cancelBarButton.action = "doCancelToTodoViewController:"
    }
    
    @IBAction func doCancelToTodoViewController(sender: UIBarButtonItem) {
        dismiss()
    }
    
    @IBAction func doAddTodo(sender: UIBarButtonItem) {
        todoDelegate?.postTodoUpdates(todoTextField.text)
        dismiss()
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

    

