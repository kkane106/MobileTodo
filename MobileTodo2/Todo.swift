//
//  Todo.swift
//  TodoMobile
//
//  Created by Kristopher Kane on 7/11/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import Foundation
import ObjectMapper

class TodoResponse: Mappable {
    var todosArray: [Todo]?
    
    init() {}
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        todosArray  <- map["todos"]
    }
}

class Todo: Mappable {
    var todoText: String?
    var todoID: Int?
    
    init(todoText: String, todoID: Int) {
        self.todoText = todoText
        self.todoID = todoID
        
    }
    
    // Mapable Protocol --> Required
    required init?(_ map: Map) {
        mapping(map)
    }
    
    // Mapable Protocol --> Required
    func mapping(map: Map) {
        todoText    <- map["text"]
        todoID      <- map["id"]
    }
}