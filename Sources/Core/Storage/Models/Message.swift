//
//  Message.swift
//  Dashing
//
//  Created by Carlo Eugster on 29.05.23.
//

import Foundation
import RealmSwift

enum MessageRole: String {
    case unknown
    case user
    case system
    case assistant
}

enum MessageStatus: String {
    case unknown
    case pending
    case final
    case error
}

final class Message: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var content: String
    @Persisted var conversationId: UUID
    @Persisted var created: Date
    
    @Persisted var role: String = MessageRole.unknown.rawValue
    var roleEnum: MessageRole {
        get { return MessageRole(rawValue: role)! }
        set { role = newValue.rawValue}
    }
    
    @Persisted var status: String? = MessageStatus.unknown.rawValue
    var statusEnum: MessageStatus {
        get { if let status = status { return MessageStatus(rawValue: status)! } else { return .unknown } }
        set { status = newValue.rawValue }
    }
}

