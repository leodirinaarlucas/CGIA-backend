//
//  Instructor.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Fluent
import FluentPostgreSQL
import Vapor

final class Instructor: PostgreSQLModel {
    var id: Int?
    var name: String
    var lastName: String
    var dateOfBirth: String
    var userID: User.ID
    public init(id: Int? = nil, name: String, lastName: String, username: String,
                dateOfBirth: String, userID: User.ID) {
        self.id = id
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.lastName = lastName
        self.userID = userID
    }
}

extension Instructor {
    var classrooms: Children<Instructor, Classroom> {
        return children(\.instructorID)
    }
}

extension Instructor: Migration {}
extension Instructor: Content {}
extension Instructor: Parameter {}
