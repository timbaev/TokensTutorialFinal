//
//  ProjectServices.swift
//  App
//
//  Created by Timur Shafigullin on 25/01/2019.
//

import Foundation

enum ProjectServices {
    
    static let userService: UserService = DefaultUserService()
    static let todoService: TodoService = DefaultTodoService()
}
