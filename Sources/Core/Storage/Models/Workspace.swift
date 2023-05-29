//
//  Workspace.swift
//  Dashing
//
//  Created by Carlo Eugster on 28.05.23.
//


import Foundation
import RealmSwift

final class Workspace: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var created: Date
    @Persisted var modified: Date
}
