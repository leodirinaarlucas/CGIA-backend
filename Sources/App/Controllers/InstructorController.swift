//
//  InstructorController.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor

final class InstructorController {
    func get(_ req: Request) throws -> Future<[Instructor]> {
          return Instructor.query(on: req).all()
      }
      
      func post(_ req: Request) throws -> Future<Instructor> {
          return try req.content.decode(Instructor.self).flatMap { instructor in
              return instructor.save(on: req)
          }
      }
}
