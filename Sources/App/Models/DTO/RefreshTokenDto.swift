//
//  RefreshTokenDto.swift
//  App
//
//  Created by Timur Shafigullin on 28/01/2019.
//

import Vapor

struct RefreshTokenDto: Content {
    let refreshToken: String
}
