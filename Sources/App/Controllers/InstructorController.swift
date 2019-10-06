//
//  InstructorController.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor

final class InstructorController {
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
