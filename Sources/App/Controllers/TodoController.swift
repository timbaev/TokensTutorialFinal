import Vapor

final class TodoController {
    
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }

    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            return todo.save(on: req)
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
}

extension TodoController: RouteCollection {
    
    func boot(router: Router) throws {
        router.get("todos", use: self.index)
        router.post("todos", use: self.create)
        router.delete("todos", Todo.parameter, use: self.delete)
    }
}
