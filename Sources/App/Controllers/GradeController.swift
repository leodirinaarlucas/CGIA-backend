//
//  GradeController.swift
//  App
//
//  Created by Artur Carneiro on 19/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class GradeController: RouteCollection {
    func boot(router: Router) throws {
        let router = router.grouped(Paths.main, Paths.grade)
        router.get(use: index)
        router.post(use: create)
        router.patch(Grade.parameter, use: update)
        router.delete(Grade.parameter, use: delete)
    }
    
    func index(_ req: Request) throws -> Future<[Grade]> {
        return Grade.query(on: req).all()
    }
    
    func create(_ req: Request) throws -> Future<Grade> {
        return try req.content.decode(Grade.self).flatMap { grade in
            return grade.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Grade.self).flatMap { admin in
            return admin.delete(on: req)
        }.transform(to: .ok)
    }
    
    func update(_ req: Request) throws -> Future<Grade> {
        return try req.parameters.next(Grade.self).flatMap { grade in
            return try req.content.decode(Grade.self).flatMap { newGrade in
                grade.grades = newGrade.grades
                grade.finalGrade = newGrade.finalGrade
                grade.studentID = newGrade.studentID
                grade.classroomID = newGrade.classroomID
                return grade.save(on: req)
            }
        }
    }
}
