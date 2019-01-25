import FluentSQLite
import Vapor

final class Todo: SQLiteModel {
    
    var id: Int?
    var title: String
    var userID: User.ID

    /// Creates a new `Todo`.
    init(id: Int? = nil, title: String, userID: User.ID) {
        self.id = id
        self.title = title
        self.userID = userID
    }
}

extension Todo {
    
    var user: Parent<Todo, User> {
        return self.parent(\.userID)
    }
}

extension Todo: Migration { }

extension Todo: Content { }

extension Todo: Parameter { }
