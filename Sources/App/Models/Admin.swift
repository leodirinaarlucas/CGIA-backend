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
    var dateOfBirth: String
    var userID: User.ID
    init(id: Int? = nil, name: String, lastName: String, username: String, dateOfBirth: String, userID: User.ID) {
        self.id = id
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.lastName = lastName
        self.userID = userID
    }
}

extension Admin: Migration {}
extension Admin: Content {}
extension Admin: Parameter {}
