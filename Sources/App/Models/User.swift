//
//  User.swift
//  App
//
//  Created by Artur Carneiro on 14/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class User: PostgreSQLModel {
    var id: Int?
    var username: String
    var password: String
    
    init(id: Int? = nil, username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
    }
}

extension User: Migration {}
extension User: Content {}
extension User: Parameter {}
