//
//  Grade.swift
//  App
//
//  Created by Artur Carneiro on 14/10/19.
//

import Foundation
import FluentPostgreSQL
import Vapor

final class Grade: PostgreSQLModel {
    var id: Int?
    var grades: [Double]
    var finalGrade: Double
    var studentID: Student.ID
    var classroomID: Classroom.ID
    
    init(id: Int? = nil, grades: [Double], student: Student.ID, finalGrade: Double, classroom: Classroom.ID) {
        self.id = id
        self.grades = grades
        self.finalGrade = finalGrade
        self.studentID = student
        self.classroomID = classroom
    }
    
    var student: Parent<Grade, Student> {
        return parent(\.studentID)
    }
    
    var classroom: Parent<Grade, Classroom> {
        return parent(\.classroomID)
    }
}

extension Grade: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.studentID, to: \Student.id)
            builder.reference(from: \.classroomID, to: \Classroom.id)
        }
    }
}
extension Grade: Content {}
extension Grade: Parameter {}
