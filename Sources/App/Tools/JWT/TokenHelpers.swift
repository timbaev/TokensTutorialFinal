//
//  TokenHelpers.swift
//  App
//
//  Created by Timur Shafigullin on 22/01/2019.
//

import JWT

class TokenHelpers {
    
    /// Create payload for Access Token
    fileprivate class func createPayload(from user: User) throws -> AccessTokenPayload {
        if let id = user.id {
            let payload = AccessTokenPayload(userID: id)
           
            return payload
        } else {
            throw JWTError.payloadCreation
        }
    }
    
    /// Create Access Token for user
    class func createAccessToken(from user: User) throws -> String {
        let payload = try TokenHelpers.createPayload(from: user)
        let header = JWTConfig.header
        let signer = JWTConfig.signer
        let jwt = JWT<AccessTokenPayload>(header: header, payload: payload)
        let tokenData = try signer.sign(jwt)
        
        if let token = String(data: tokenData, encoding: .utf8) {
            return token
        } else {
            throw JWTError.createJWT
        }
    }
    
    /// Get expiration date of token
    class func expiredDate(of token: String) throws -> Date {
        let receivedJWT = try JWT<AccessTokenPayload>(from: token, verifiedUsing: JWTConfig.signer)
        
        return receivedJWT.payload.expirationAt.value
    }
    
    /// Verify token is valid or not
    class func verifyToken(_ token: String) throws {
        do {
            let _ = try JWT<AccessTokenPayload>(from: token, verifiedUsing: JWTConfig.signer)
        } catch {
            throw JWTError.verificationFailed
        }
    }
    
    /// Get user ID from token
    class func getUserID(fromPayloadOf token: String) throws -> Int {
        do {
            let receivedJWT = try JWT<AccessTokenPayload>(from: token, verifiedUsing: JWTConfig.signer)
            let payload = receivedJWT.payload
            
            return payload.userID
        } catch {
            throw JWTError.verificationFailed
        }
    }
}
