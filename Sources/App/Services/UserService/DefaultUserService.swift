//
//  DefaultUserService.swift
//  App
//
//  Created by Timur Shafigullin on 25/01/2019.
//

import Vapor
import Crypto
import FluentSQLite

struct DefaultUserService: UserService {
    
    func signUp(request: Request, user: User) throws -> EventLoopFuture<ResponseDto> {
        return User.query(on: request).filter(\.login == user.login).first().flatMap { existingUser in
            guard existingUser == nil else {
                throw Abort(.badRequest, reason: "A user with login \(user.login) already exists")
            }
            
            let digest = try request.make(BCryptDigest.self)
            let hashedPassword = try digest.hash(user.password)
            let persistedUser = User(login: user.login, password: hashedPassword)
            
            return persistedUser.save(on: request).transform(to: ResponseDto(message: "Account created successfully"))
        }
    }
}
