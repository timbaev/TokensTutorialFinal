//
//  TodoService.swift
//  App
//
//  Created by Timur Shafigullin on 26/01/2019.
//

import Vapor

protocol TodoService {
    
    func create(request: Request, todoDto: TodoDto) throws -> Future<TodoDto>
    func fetch(request: Request) throws -> Future<[TodoDto]>
    func delete(request: Request, todoID: Int) throws -> Future<TodoDto>
}
