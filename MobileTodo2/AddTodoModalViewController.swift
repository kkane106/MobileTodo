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
    func postTodoUpdates()
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
        //        // THIS ACTUALLY NEEDS TO SEND A NEW OBJECT TO BE SAVED ON DB, THEN THE RESPONSE WILL CREATE A NEW TODO OBJECT IN SWIFT WITH THE ID, FINALLY THE OBJECT WILL BE APPENDED TO THE ARRAY AND IT'S TEXT WILL BE DISPLAYED...OY VEY
//        todoDelegate?.addTodo(todoTextField.text)
        todoDelegate?.postTodoUpdates()
//
        dismiss()
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

    

