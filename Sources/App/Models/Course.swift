//
//  Course.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Fluent

final class Course: PostgreSQLModel {
    var id: Int?
    var name: String
    var instructorID: Instructor.ID
    
    public init(id: Int? = nil, name: String, instructorID: Instructor.ID) {
        self.id = id
        self.name = name
        self.instructorID = instructorID
    }
}

extension Course {
    var instructor: Parent<Course, Instructor> {
        return parent(\.instructorID)
    }
}

extension Course: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.instructorID, to: \Instructor.id)
        }
    }
}
extension Course: Content {}
extension Course: Parameter {}
