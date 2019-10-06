//
//  CourseController.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor

final class CourseController {
    func get(_ req: Request) throws -> Future<[Course]> {
          return Course.query(on: req).all()
      }
      
      func post(_ req: Request) throws -> Future<Course> {
          return try req.content.decode(Course.self).flatMap { course in
              return course.save(on: req)
          }
      }
}
