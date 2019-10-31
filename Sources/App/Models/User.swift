//
//  User.swift
//  App
//
//  Created by Artur Carneiro on 14/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Authentication

enum Profile {
    static let student: String = "student"
    static let instructor: String = "instructor"
    static let admin: String = "admin"
}

final class User: PostgreSQLModel {
    var id: Int?
    var username: String
    var password: String
    var profile: String
    
    init(id: Int? = nil, username: String, password: String, profile: String) {
        self.id = id
        self.username = username
        self.password = password
        switch profile.lowercased() {
        case Profile.student.lowercased():
            self.profile = profile.lowercased()
        case Profile.instructor.lowercased():
            self.profile = profile.lowercased()
        case Profile.admin.lowercased():
            self.profile = profile.lowercased()
        default:
            self.profile = "undefined"
        }
    }
}

extension User: Migration {}
extension User: Content {}
extension User: Parameter {}
extension User: BasicAuthenticatable {
    static let usernameKey: WritableKeyPath<User, String> = \.username
    static let passwordKey: WritableKeyPath<User, String> = \.password
}
