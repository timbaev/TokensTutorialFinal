//
//  TodoDto.swift
//  App
//
//  Created by Timur Shafigullin on 26/01/2019.
//

import Vapor

struct TodoDto: Content {
    
    let id: Int?
    let title: String
}
