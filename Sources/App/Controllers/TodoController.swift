import Vapor

final class TodoController {
    
    fileprivate var todoService: TodoService
    
    init(todoService: TodoService) {
        self.todoService = todoService
    }
    
    func fetch(_ req: Request) throws -> Future<[TodoDto]> {
        return try self.todoService.fetch(request: req)
    }

    func create(_ req: Request, todoDto: TodoDto) throws -> Future<TodoDto> {
        return try self.todoService.create(request: req, todoDto: todoDto)
    }

    func delete(_ req: Request) throws -> Future<TodoDto> {
        let todoID = try req.parameters.next(Int.self)
        return try self.todoService.delete(request: req, todoID: todoID)
    }
}

extension TodoController: RouteCollection {
    
    func boot(router: Router) throws {
        let group = router.grouped("v1/todo").grouped(JWTMiddleware())
        
        group.post(TodoDto.self, use: self.create)
        group.get(use: self.fetch)
        group.delete(Int.parameter, use: self.delete)
    }
}
