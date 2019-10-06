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
    var instructorID: Int
    
    init(id: Int? = nil, name: String, instructorID: Instructor.ID) {
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

extension Course: Migration {}
extension Course: Content {}
extension Course: Parameter {}
