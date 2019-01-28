//
//  RequestExtensions.swift
//  App
//
//  Created by Timur Shafigullin on 23/01/2019.
//

import Vapor
import JWT

extension Request {
    
    var token: String {
        if let token = self.http.headers[.authorization].first {
            return token
        } else {
            return ""
        }
    }
    
    func authorizedUser() throws -> Future<User> {
        let userID = try TokenHelpers.getUserID(fromPayloadOf: self.token)
        
        return User.find(userID, on: self).unwrap(or: Abort(.unauthorized, reason: "Authorized user not found"))
    }
}
