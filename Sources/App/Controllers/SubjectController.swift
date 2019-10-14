//
//  SubjectController.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor

struct CompleteSubject: Content {
    let id: Int
    let name: String
    var classrooms: [Classroom]
}

final class CourseController: RouteCollection {
    func boot(router: Router) throws {
        let router = router.grouped(Paths.main, Paths.subjects)
        router.get(use: index)
        router.get(Subject.parameter, use: getSubject)
        router.get(Subject.parameter, Paths.classroom, use: getClassrooms)
        router.post(use: create)
        router.patch(Subject.parameter, use: update)
        router.delete(Subject.parameter, use: delete)
    }
    
    func index(_ req: Request) throws -> Future<[Subject]> {
        return Subject.query(on: req).all()
      }
    
    func getSubject(_ req: Request) throws -> Future<CompleteSubject> {
        return try req.parameters.next(Subject.self).flatMap(to: CompleteSubject.self) { course in
            return try course.classrooms.query(on: req).all().map(to: CompleteSubject.self) { classrooms in
                return try CompleteSubject(id: course.requireID(), name: course.name, classrooms: classrooms)
            }
        }
    }
    
    func getClassrooms(_ req: Request) throws -> Future<[Classroom]> {
        return try req.parameters.next(Subject.self).flatMap(to: [Classroom].self) { subject in
            return try subject.classrooms.query(on: req).all()
        }
    }
    
    func create(_ req: Request) throws -> Future<Subject> {
        return try req.content.decode(Subject.self).flatMap { course in
            return course.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Subject.self).flatMap { course in
            return course.delete(on: req)
        }.transform(to: .ok)
    }
    
    func update(_ req: Request) throws -> Future<Subject> {
        return try req.parameters.next(Subject.self).flatMap {
            subject in
            return try req.content.decode(Subject.self).flatMap { newSubject in
                subject.name = newSubject.name
                return subject.save(on: req)
            }
        }
    }
}
