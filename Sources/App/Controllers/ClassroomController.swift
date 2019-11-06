//
//  ClassroomController.swift
//  App
//
//  Created by Artur Carneiro on 14/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct CompleteClassroom: Content {
    let id: Int
    let name: String
    let subjectID: Subject.ID
    let instructorID: Instructor.ID
    var grades: [Grade]
    var instructor: Instructor
    var subject: Subject
    var students: [Student]
    var active: Bool
}

final class ClassroomController: RouteCollection {
    func boot(router: Router) throws {
        let router = router.grouped(Paths.main, Paths.classroom)
        router.get(use: index)
        router.get(Classroom.parameter, use: getClassroom)
        router.get(Classroom.parameter, Paths.subjects, use: getSubject)
        router.get(Classroom.parameter, Paths.grade, use: getGrades)
        router.get(Classroom.parameter, Paths.instructors, use: getInstructor)
        router.post(use: create)
        router.patch(Classroom.parameter, use: update)
        router.delete(Classroom.parameter, use: delete)
    }
    
    func index(_ req: Request) throws -> Future<[Classroom]> {
        return Classroom.query(on: req).all()
    }
    
    func getClassroom(_ req: Request) throws -> Future<CompleteClassroom> {
        return try req.parameters.next(Classroom.self).flatMap(to: CompleteClassroom.self) { classroom in
            return try classroom.grades.query(on: req).all().flatMap(to: CompleteClassroom.self) { grades in
                return classroom.instructor.get(on: req).flatMap(to: CompleteClassroom.self) { instructor in
                    return classroom.subject.get(on: req).flatMap(to: CompleteClassroom.self) { subject in
                        return try classroom.students.query(on: req).all().map(to: CompleteClassroom.self) { students in
                            return try CompleteClassroom(id: classroom.requireID(), name: classroom.name,
                                                         subjectID: classroom.subjectID,
                                                         instructorID: classroom.instructorID, grades: grades,
                                                         instructor: instructor, subject: subject,
                                                         students: students, active: classroom.active)
                        }
                    }
                }
            }
        }
    }
    
    func getGrades(_ req: Request) throws -> Future<[Grade]> {
        return try req.parameters.next(Classroom.self).flatMap(to: [Grade].self) { classroom in
            return try classroom.grades.query(on: req).all()
        }
    }
    
    func getInstructor(_ req: Request) throws -> Future<Instructor> {
        return try req.parameters.next(Classroom.self).flatMap(to: Instructor.self) { classroom in
            return classroom.instructor.get(on: req)
        }
    }
    
    func getSubject(_ req: Request) throws -> Future<Subject> {
        return try req.parameters.next(Classroom.self).flatMap(to: Subject.self) { classroom in
            return classroom.subject.get(on: req)
        }
    }
    
    func create(_ req: Request) throws -> Future<Classroom> {
        return try req.content.decode(Classroom.self).flatMap { classroom in
            return classroom.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Classroom.self).flatMap {
            classroom in
            return classroom.delete(on: req)
        }.transform(to: .ok)
    }
    func update(_ req: Request) throws -> Future<Classroom> {
        return try req.parameters.next(Classroom.self).flatMap { classroom in
            return try req.content.decode(Classroom.self).flatMap { newClassroom in
                classroom.name = newClassroom.name
                classroom.subjectID = newClassroom.subjectID
                classroom.instructorID = newClassroom.instructorID
                return classroom.save(on: req)
            }
        }
    }
}
