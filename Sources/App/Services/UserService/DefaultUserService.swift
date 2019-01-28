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
    
    func signUp(request: Request, user: User) throws -> Future<ResponseDto> {
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
    
    func signIn(request: Request, user: User) throws -> Future<AccessDto> {
        return User
            .query(on: request)
            .filter(\.login == user.login)
            .first()
            .unwrap(or: Abort(.badRequest, reason: "User with login \(user.login) not found"))
            .flatMap { persistedUser in
                let digest = try request.make(BCryptDigest.self)
                
                if try digest.verify(user.password, created: persistedUser.password) {
                    let accessToken = try TokenHelpers.createAccessToken(from: persistedUser)
                    let expiredAt = try TokenHelpers.expiredDate(of: accessToken)
                    let accessDto = AccessDto(accessToken: accessToken, expiredAt: expiredAt)
                    
                    return request.future(accessDto)
                } else {
                    throw Abort(.badRequest, reason: "Incorrect user password")
                }
        }
    }
}
