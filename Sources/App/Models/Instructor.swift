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
    
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension Instructor {
    var courses: Children<Instructor, Course> {
        return children(\.instructorID)
    }
}

extension Instructor: Migration {}
extension Instructor: Content {}
extension Instructor: Parameter {}
