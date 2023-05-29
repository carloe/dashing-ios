//
//  Message.swift
//  Dashing
//
//  Created by Carlo Eugster on 29.05.23.
//

import Foundation
import RealmSwift

final class Message: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var content: String
    @Persisted var conversationId: UUID
    @Persisted var created: Date
    @Persisted var role: String
    @Persisted var status: String? = nil
}

