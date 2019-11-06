//
//  Student.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Fluent

final class Student: PostgreSQLModel {
    var id: Int?
    var name: String
    var lastName: String
    var dateOfBirth: String
    var userID: User.ID
    public init(id: Int? = nil, name: String, lastName: String, dateOfBirth: String, userID: User.ID) {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.userID = userID
    }
    var classrooms: Siblings<Student, Classroom, StudentClassroom> {
        return siblings()
    }
    var grades: Children<Student, Grade> {
        return children(\.studentID)
    }
}

extension Student: Migration {}
extension Student: Content {}
extension Student: Parameter {}
