import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // MARK: - TodoController
    
    let todoController = TodoController()
    
    try router.register(collection: todoController)
    
    // MARK: - UserController
    
    let userController = UserController(userService: ProjectServices.userService)
    
    try router.register(collection: userController)
}
