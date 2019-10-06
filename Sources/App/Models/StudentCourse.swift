//
//  StudentCourse.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Fluent

final class StudentCourse: PostgreSQLPivot, ModifiablePivot {
    init(_ left: Student, _ right: Course) throws {
        self.studentID = try left.requireID()
        self.courseID = try right.requireID()
    }
    
    typealias Left = Student
    
    typealias Right = Course
    
    static var leftIDKey: WritableKeyPath<StudentCourse, Int> = \.studentID
    static var rightIDKey: WritableKeyPath<StudentCourse, Int> = \.courseID
    
    var id: Int?
    var studentID: Student.ID
    var courseID: Course.ID
}

extension StudentCourse {
    
}

extension StudentCourse: Migration {}
extension StudentCourse: Content {}
extension StudentCourse: Parameter {}
