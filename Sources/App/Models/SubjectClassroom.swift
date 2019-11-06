//
//  SubjectClassroom.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Fluent

final class SubjectClassroom: PostgreSQLPivot, ModifiablePivot {
    init(_ left: Student, _ right: Subject) throws {
        self.studentID = try left.requireID()
        self.courseID = try right.requireID()
    }
    typealias Left = Student
    typealias Right = Subject
    static var leftIDKey: WritableKeyPath<SubjectClassroom, Int> = \.studentID
    static var rightIDKey: WritableKeyPath<SubjectClassroom, Int> = \.courseID
    var id: Int?
    var studentID: Student.ID
    var courseID: Subject.ID
}

extension SubjectClassroom {
}

extension SubjectClassroom: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.courseID, to: \Subject.id, onDelete: .cascade)
            builder.reference(from: \.studentID, to: \Student.id, onDelete: .cascade)
        }
    }
}
extension SubjectClassroom: Content {}
extension SubjectClassroom: Parameter {}
