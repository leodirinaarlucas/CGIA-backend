//
//  CourseController.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor

final class CourseController: RouteCollection {
    func boot(router: Router) throws {
        let courseControllerRoute = router.grouped(Paths.main, Paths.courses)
        courseControllerRoute.get(use: index)
        courseControllerRoute.get(Course.parameter, use: getCourse)
        courseControllerRoute.post(use: create)
        courseControllerRoute.patch(Course.parameter, use: update)
        courseControllerRoute.delete(Course.parameter, use: delete)
    }
    
    func index(_ req: Request) throws -> Future<[Course]> {
          return Course.query(on: req).all()
      }
    
    func getCourse(_ req: Request) throws -> Future<Course> {
        return try req.parameters.next(Course.self)
    }
    
    func create(_ req: Request) throws -> Future<Course> {
        return try req.content.decode(Course.self).flatMap { course in
            return course.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Course.self).flatMap { course in
            return course.delete(on: req)
        }.transform(to: .ok)
    }
    
    func update(_ req: Request) throws -> Future<Course> {
        return try req.parameters.next(Course.self).flatMap {
            course in
            return try req.content.decode(Course.self).flatMap { newCourse in
                course.name = newCourse.name
                return course.save(on: req)
            }
        }
    }
}
