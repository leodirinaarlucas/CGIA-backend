//
//  Student.swift
//  App
//
//  Created by Artur Carneiro on 06/10/19.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Fluent

final class Student: PostgreSQLModel {
    var id: Int?
    var name: String
    
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension Student {
    
}

extension Student: Migration {}
extension Student: Content {}
extension Student: Parameter {}
