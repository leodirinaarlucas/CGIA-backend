//
//  StudentController.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor

final class StudentController: RouteCollection {
    func boot(router: Router) throws {
        let studentControllerRoute = router.grouped(Paths.main, Paths.students)
        studentControllerRoute.get(use: index)
        studentControllerRoute.get(Student.parameter, use: getStudent)
        studentControllerRoute.post(use: create)
        studentControllerRoute.patch(Student.parameter, use: update)
        studentControllerRoute.delete(Student.parameter, use: delete)
    }
    
    func index(_ req: Request) throws -> Future<[Student]> {
        return Student.query(on: req).all()
    }
    
    func getStudent(_ req: Request) throws -> Future<Student> {
        return try req.parameters.next(Student.self)
    }
    
    func create(_ req: Request) throws -> Future<Student> {
        return try req.content.decode(Student.self).flatMap { student in
            return student.save(on: req)
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
                return student.save(on: req)
            }
        }
    }
}
