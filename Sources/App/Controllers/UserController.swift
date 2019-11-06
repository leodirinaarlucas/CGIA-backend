//
//  UserController.swift
//  App
//
//  Created by Artur Carneiro on 14/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Crypto
import Authentication

struct PublicUser: Content {
    var id: Int?
    var username: String
    var profile: String
}

final class UserController: RouteCollection {
    func boot(router: Router) throws {
        let router = router.grouped(Paths.main, Paths.user)
        router.get(use: index)
        router.post(use: create)
        router.delete(User.parameter, use: delete)
        router.patch(User.parameter, use: update)
        
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCrypt)
        let guardAuthMiddlewar = User.guardAuthMiddleware()
        let authGroup = router.grouped([basicAuthMiddleware, guardAuthMiddlewar])
        authGroup.get(String.parameter, use: getUser)
    }
    
    func index(_ req: Request) throws -> Future<[PublicUser]> {
        return User.query(on: req).decode(data: PublicUser.self).all()
    }
    
    func getUser(_ req: Request) throws -> Future<PublicUser> {
        let authUsername = try req.parameters.next(String.self)
        return User.query(on: req).filter(\.username == authUsername).first().map(to: PublicUser.self) { user in
            guard let user = user else {
                throw Abort(.badRequest, reason: "No user with this username exists.")
            }
            return PublicUser(id: user.id, username: user.username, profile: user.profile)
        }
    }
    
    func create(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { newUser in
            return User.query(on: req).filter(\.username == newUser.username).first().flatMap { user in
                guard user == nil else {
                    throw Abort(.badRequest, reason:"A user with this username already exists.")
                }
                let digest = try req.make(BCryptDigest.self)
                let hashedPassword = try digest.hash(newUser.password)
                let updatedNewUser = User(id: newUser.id, username: newUser.username, password: hashedPassword, profile: newUser.profile)
                return updatedNewUser.save(on: req)
            }
            
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
