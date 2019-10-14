//
//  InstructorController.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor

struct CompleteInstructor: Content {
    let id: Int
    let name: String
    let lastName: String
    let username: String
    let dateOfBirth: String
    var classrooms: [Classroom]
}

final class InstructorController: RouteCollection {
    func boot(router: Router) throws {
        let router = router.grouped(Paths.main, Paths.instructors)
        router.get(use: index)
        router.get(Instructor.parameter, use: getInstructor)
        router.get(Instructor.parameter, Paths.classroom, use: getClassrooms)
        router.post(use: create)
        router.patch(Instructor.parameter, use: update)
        router.delete(Instructor.parameter, use: delete)
    }
    
    func index(_ req: Request) throws -> Future<[Instructor]> {
          return Instructor.query(on: req).all()
      }
    
    func getInstructor(_ req: Request) throws -> Future<CompleteInstructor> {
        return try req.parameters.next(Instructor.self).flatMap(to: CompleteInstructor.self) { instructor in
            return try instructor.classrooms.query(on: req).all().map(to: CompleteInstructor.self) { classrooms in
                return try CompleteInstructor(id: instructor.requireID(), name: instructor.name, lastName: instructor.lastName, username: instructor.username, dateOfBirth: instructor.dateOfBirth, classrooms: classrooms)
            }
        }
    }
    
    func getClassrooms(_ req: Request) throws -> Future<[Classroom]> {
        return try req.parameters.next(Instructor.self).flatMap(to: [Classroom].self) { instructor in
            return try instructor.classrooms.query(on: req).all()
        }
    }
      
    func create(_ req: Request) throws -> Future<Instructor> {
          return try req.content.decode(Instructor.self).flatMap { instructor in
              return instructor.save(on: req)
          }
      }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Instructor.self).flatMap { instructor in
            return instructor.delete(on: req)
        }.transform(to: .ok)
    }
    
    func update(_ req: Request) throws -> Future<Instructor> {
        return try req.parameters.next(Instructor.self).flatMap { instructor in
            return try req.content.decode(Instructor.self).flatMap { newInstructor in
                instructor.name = newInstructor.name
                instructor.lastName = newInstructor.lastName
                instructor.username = newInstructor.username
                instructor.dateOfBirth = newInstructor.dateOfBirth
                return instructor.save(on: req)
            }
        }
    }
}
