//
//  StudentClassroom.swift
//  App
//
//  Created by Artur Carneiro on 14/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class StudentClassroom: PostgreSQLPivot, ModifiablePivot {
    init(_ left: StudentClassroom.Left, _ right: StudentClassroom.Right) throws {
        self.studentID = try left.requireID()
        self.classroomID = try right.requireID()
    }
    
    typealias Left = Student
    
    typealias Right = Classroom
    
    static var leftIDKey: WritableKeyPath<StudentClassroom, Int> = \.studentID
    static var rightIDKey: WritableKeyPath<StudentClassroom, Int> = \.classroomID
    var id: Int?
    var studentID: Student.ID
    var classroomID: Classroom.ID
}

extension StudentClassroom: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.classroomID, to: \Classroom.id, onDelete: .cascade)
            builder.reference(from: \.studentID, to: \Student.id, onDelete: .cascade)
        }
    }
}
extension StudentClassroom: Content {}
extension StudentClassroom: Parameter {}
