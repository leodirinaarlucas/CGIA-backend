//
//  Admin.swift
//  App
//
//  Created by Artur Carneiro on 14/10/19.
//

import Foundation
import FluentPostgreSQL
import Vapor

final class Admin: PostgreSQLModel {
    var id: Int?
    var name: String
    var lastName: String
    var username: String
    var dateOfBirth: String
    
    init(id: Int? = nil, name: String, lastName: String, username: String, dateOfBirth: String) {
        self.id = id
        self.name = name
        self.username = username
        self.dateOfBirth = dateOfBirth
        self.lastName = lastName
    }
}

extension Admin: Migration {}
extension Admin: Content {}
extension Admin: Parameter {}
