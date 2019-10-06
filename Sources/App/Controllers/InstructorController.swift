//
//  InstructorController.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor

final class InstructorController: RouteCollection {
    func boot(router: Router) throws {
        let instructorControllerRoute = router.grouped(Paths.main, Paths.instructors)
        instructorControllerRoute.get(use: index)
        instructorControllerRoute.get(Instructor.parameter, use: getInstructor)
        instructorControllerRoute.post(use: create)
        instructorControllerRoute.patch(Instructor.parameter, use: update)
        instructorControllerRoute.delete(Instructor.parameter, use: delete)
    }
    
    func index(_ req: Request) throws -> Future<[Instructor]> {
          return Instructor.query(on: req).all()
      }
    
    func getInstructor(_ req: Request) throws -> Future<Instructor> {
        return try req.parameters.next(Instructor.self)
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
                return instructor.save(on: req)
            }
        }
    }
}
