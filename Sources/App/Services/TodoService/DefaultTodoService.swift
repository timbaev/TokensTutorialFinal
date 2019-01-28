//
//  DefaultTodoService.swift
//  App
//
//  Created by Timur Shafigullin on 26/01/2019.
//

import Vapor
import FluentSQLite

struct DefaultTodoService: TodoService {
    
    func create(request: Request, todoDto: TodoDto) throws -> Future<TodoDto> {
        return try request.authorizedUser().flatMap { user in
            return Todo(title: todoDto.title, userID: try user.requireID()).save(on: request).flatMap { todo in
                return request.future(TodoDto(id: try todo.requireID(), title: todo.title))
            }
        }
    }
    
    func fetch(request: Request) throws -> Future<[TodoDto]> {
        return try request.authorizedUser().flatMap { user in
            return try user.todos.query(on: request).all().flatMap { todos in
                return request.future(try todos.map { TodoDto(id: try $0.requireID(), title: $0.title) })
            }
        }
    }
    
    func delete(request: Request, todoID: Int) throws -> Future<TodoDto> {
        return try request.authorizedUser().flatMap { user in
            return try user
                .todos
                .query(on: request)
                .filter(\.id == todoID)
                .first()
                .unwrap(or: Abort(.badRequest, reason: "User don't have todo with id \(todoID)"))
                .delete(on: request)
                .flatMap { todo in
                    return request.future(TodoDto(id: try todo.requireID(), title: todo.title))
            }
        }
    }
}
