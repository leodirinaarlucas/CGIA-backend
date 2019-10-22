//
//  StudentClassroomController.swift
//  App
//
//  Created by Artur Carneiro on 22/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class StudentClassroomController: RouteCollection {
    func boot(router: Router) throws {
        let router: Router = router.grouped(Paths.main, Paths.stuClass)
        router.get(use: index)
        router.post(use: create)
        router.patch(StudentClassroom.parameter, use: update)
        router.delete(StudentClassroom.parameter, use: delete)
    }
    
    func index(_ req: Request) throws -> Future<[StudentClassroom]> {
        return StudentClassroom.query(on: req).all()
    }
    
    func create(_ req: Request) throws -> Future<StudentClassroom> {
        return try req.content.decode(StudentClassroom.self).flatMap() { stuClass in
            return stuClass.save(on: req)
        }
    }
    
    func update(_ req: Request) throws -> Future<StudentClassroom> {
        return try req.parameters.next(StudentClassroom.self).flatMap {
            stuClass in
            return try req.content.decode(StudentClassroom.self).flatMap {
                newStuClass in
                stuClass.studentID = newStuClass.studentID
                stuClass.classroomID = newStuClass.classroomID
                return stuClass.save(on: req)
            }
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(StudentClassroom.self).flatMap { stuClass in
            return stuClass.delete(on: req)
        }.transform(to: .ok)
    }
}
