//
//  StudentController.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor

final class StudentController {
    func get(_ req: Request) throws -> Future<[Student]> {
        return Student.query(on: req).all()
    }
    
    func post(_ req: Request) throws -> Future<Student> {
        return try req.content.decode(Student.self).flatMap { student in
            return student.save(on: req)
        }
    }
}
