import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // MARK: - Router
    
    let router = EngineRouter.default()
    
    try routes(router)
    
    services.register(router, as: Router.self)
    
    // MARK: - Directory
    
    let directoryConfig = DirectoryConfig.detect()
    
    services.register(directoryConfig)
    
    // MARK: - Middlewares
    
    var middlewares = MiddlewareConfig()
    
    middlewares.use(ErrorMiddleware.self)
    
    services.register(middlewares)
    
    // MARK: - SQLite
    
    try services.register(FluentSQLiteProvider())
    
    let sqlite = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)database.db"))
    
    var databases = DatabasesConfig()
    
    databases.add(database: sqlite, as: .sqlite)
    
    services.register(databases)
    
    // MARK: - Migration
    
    var migrations = MigrationConfig()
    
    migrations.add(model: Todo.self, database: .sqlite)
    migrations.add(model: User.self, database: .sqlite)
    migrations.add(model: RefreshToken.self, database: .sqlite)
    
    services.register(migrations)
}
