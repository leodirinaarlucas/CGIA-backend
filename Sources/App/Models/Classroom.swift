//
//  Classroom.swift
//  App
//
//  Created by Artur Carneiro on 14/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class Classroom: PostgreSQLModel {
    var id: Int?
    var name: String
    var subjectID: Subject.ID
    var instructorID: Instructor.ID
    var active: Bool
    init(id: Int? = nil, name: String, subjectID: Subject.ID, instructorID: Instructor.ID, active: Bool) {
        self.id = id
        self.name = name
        self.subjectID = subjectID
        self.instructorID = instructorID
        self.active = active
    }
    var grades: Children<Classroom, Grade> {
        return children(\.classroomID)
    }
    var instructor: Parent<Classroom, Instructor> {
        return parent(\.instructorID)
    }
    var subject: Parent<Classroom, Subject> {
        return parent(\.subjectID)
    }
    var students: Siblings<Classroom, Student, StudentClassroom> {
        return siblings()
    }
}
extension Classroom: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.instructorID, to: \Instructor.id)
            builder.reference(from: \.subjectID, to: \Subject.id)
        }
    }
}
extension Classroom: Content {}
extension Classroom: Parameter {}
