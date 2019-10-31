//
//  AdminController.swift
//  App
//
//  Created by Artur Carneiro on 14/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class AdminController: RouteCollection {
    func boot(router: Router) throws {
        let router = router.grouped(Paths.main, Paths.admin)
        router.get(use: index)
        router.get(Admin.parameter, use: getAdmin)
        router.post(use: create)
        router.delete(Admin.parameter, use: delete)
        router.patch(Admin.parameter, use: update)
    }
    
    func index(_ req: Request) throws -> Future<[Admin]> {
        return Admin.query(on: req).all()
    }
    
    func getAdmin(_ req: Request) throws -> Future<Admin> {
        return try req.parameters.next(Admin.self)
    }
    
    func create(_ req: Request) throws -> Future<Admin> {
        return try req.content.decode(Admin.self).flatMap { admin in
            return User.find(admin.userID, on: req).flatMap { user in
            guard user != nil else {
                throw Abort(.badRequest, reason: "No user with this ID exists.")
                }
            return admin.save(on: req)
            }
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Admin.self).flatMap { admin in
            return admin.delete(on: req)
        }.transform(to: .ok)
    }
    
    func update(_ req: Request) throws -> Future<Admin> {
        return try req.parameters.next(Admin.self).flatMap { admin in
            return try req.content.decode(Admin.self).flatMap { newAdmin in
                admin.name = newAdmin.name
                admin.lastName = newAdmin.lastName
                return admin.save(on: req)
            }
        }
    }
    
    
}
