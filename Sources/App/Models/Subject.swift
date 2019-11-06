//
//  Subject.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Fluent

final class Subject: PostgreSQLModel {
    var id: Int?
    var name: String
    public init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
    var classrooms: Children<Subject, Classroom> {
        return children(\.subjectID)
    }
}

extension Subject: Migration {
}
extension Subject: Content {}
extension Subject: Parameter {}
