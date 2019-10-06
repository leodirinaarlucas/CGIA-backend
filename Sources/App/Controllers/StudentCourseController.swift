//
//  StudentCourseController.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor

final class StudentCourseController {
    func index(_ req: Request) throws -> Future<[StudentCourse]> {
          return StudentCourse.query(on: req).all()
      }
      
      func create(_ req: Request) throws -> Future<StudentCourse> {
          return try req.content.decode(StudentCourse.self).flatMap { studentCourse in
              return studentCourse.save(on: req)
          }
      }
}
