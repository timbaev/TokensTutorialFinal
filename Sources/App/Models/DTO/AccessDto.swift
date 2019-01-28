//
//  AccessDto.swift
//  App
//
//  Created by Timur Shafigullin on 25/01/2019.
//

import Vapor

struct AccessDto: Content {
    let accessToken: String
    let expiredAt: Date
}
