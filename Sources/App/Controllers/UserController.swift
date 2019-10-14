//
//  UserController.swift
//  App
//
//  Created by Artur Carneiro on 14/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class UserController: RouteCollection {
    func boot(router: Router) throws {
        let router = router.grouped(Paths.main, Paths.user)
        router.get(use: index)
        router.get(User.parameter, use: getUser)
        router.post(use: create)
        router.delete(User.parameter, use: delete)
        router.patch(User.parameter, use: update)
    }
    
    func index(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    func getUser(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
    
    func create(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { user in
            return user.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap { user in
            return user.delete(on: req)
        }.transform(to: .ok)
    }
    
    func update(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self).flatMap { user in
            return try req.content.decode(User.self).flatMap { newUser in
                user.username = newUser.username
                user.password = newUser.password
                return user.save(on: req)
            }
        }
    }
    
}
