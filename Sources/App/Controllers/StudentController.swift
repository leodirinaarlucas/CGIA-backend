//
//  StudentController.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct CompleteStudent: Content {
    let id: Int
    let name: String
    let lastName: String
    let dateOfBirth: String
    var classrooms: [Classroom]
    var grades: [Grade]
    var userID: User.ID
}
final class StudentController: RouteCollection {
    func boot(router: Router) throws {
        let router = router.grouped(Paths.main, Paths.students)
        router.get(use: index)
        router.get(Student.parameter, use: getStudent)
        router.get(Student.parameter, Paths.classroom, use: getClasses)
        router.get(Student.parameter, Paths.grade, use: getGrades)
        router.get(Paths.getByUserID, Int.parameter, use: getByUserID)
        router.post(use: create)
        router.patch(Student.parameter, use: update)
        router.delete(Student.parameter, use: delete)
    }
    
    func index(_ req: Request) throws -> Future<[Student]> {
        return Student.query(on: req).all()
    }
    
    func getStudent(_ req: Request) throws -> Future<CompleteStudent> {
        return try req.parameters.next(Student.self).flatMap(to: CompleteStudent.self) { student in
            return try student.classrooms.query(on: req).all().flatMap(to: CompleteStudent.self) { classrooms in
                return try student.grades.query(on: req).all().map(to: CompleteStudent.self) { grades in
                    return try CompleteStudent(id: student.requireID(), name: student.name,
                                               lastName: student.lastName, dateOfBirth: student.dateOfBirth, classrooms: classrooms,
                                               grades: grades, userID: student.userID)
                }
            }
        }
    }
    
    func getByUserID(_ req: Request) throws -> Future<Student> {
        let id = try req.parameters.next(Int.self)
        return Student.query(on: req).filter(\.userID == id).first().map(to: Student.self) { student in
            guard let student = student else {
                throw Abort(.badRequest, reason: "Calebe")
            }
            return student
        }
    }
    
    func create(_ req: Request) throws -> Future<Student> {
        return try req.content.decode(Student.self).flatMap { student in
            return User.find(student.userID, on: req).flatMap { user in
                guard user != nil else {
                    throw Abort(.badRequest, reason: "No user with this ID exists.")
                }
                return student.save(on: req)
            }
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Student.self).flatMap { student in
            return student.delete(on: req)
        }.transform(to: .ok)
    }
    
    func update(_ req: Request) throws -> Future<Student> {
        return try req.parameters.next(Student.self).flatMap { student in
            return try req.content.decode(Student.self).flatMap { newStudent in
                student.name = newStudent.name
                student.lastName = newStudent.lastName
                student.dateOfBirth = newStudent.dateOfBirth
                return student.save(on: req)
            }
        }
    }
    func getClasses(_ req: Request) throws -> Future<[Classroom]> {
        return try req.parameters.next(Student.self).flatMap(to: [Classroom].self) { student in
            return try student.classrooms.query(on: req).all()
        }
    }
    func getGrades(_ req: Request) throws -> Future<[Grade]> {
        return try req.parameters.next(Student.self).flatMap(to: [Grade].self) { student in
            return try student.grades.query(on: req).all()
        }
    }
}
