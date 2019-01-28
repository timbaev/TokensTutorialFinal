//
//  User.swift
//  App
//
//  Created by Timur Shafigullin on 25/01/2019.
//

import FluentSQLite
import Vapor

final class User: SQLiteModel {
    
    var id: Int?
    var login: String
    var password: String
    
    init(id: Int? = nil, login: String, password: String) {
        self.id = id
        self.login = login
        self.password = password
    }
}

extension User {
    
    var todos: Children<User, Todo> {
        return self.children(\.userID)
    }
    
    var refreshTokens: Children<User, RefreshToken> {
        return self.children(\.userID)
    }
}

extension User: SQLiteMigration {
    
    static func prepare(on conn: SQLiteDatabase.Connection) -> Future<Void> {
        return Database.create(User.self, on: conn, closure: { builder in
            try self.addProperties(to: builder)
            
            builder.unique(on: \.login)
        })
    }
}

extension User: Content { }

extension User: Parameter { }
