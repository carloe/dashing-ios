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

enum MessageState: String {
    case unknown
    case pending
    case confirmed
    case rejected
}

final class Message: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var content: String
    @Persisted var conversationId: UUID
    @Persisted var created: Date
    @Persisted var modified: Date
    
    @Persisted var role: String = MessageRole.unknown.rawValue
    var roleEnum: MessageRole {
        get { return MessageRole(rawValue: role)! }
        set { role = newValue.rawValue}
    }
    
    @Persisted var state: String? = MessageState.unknown.rawValue
    var stateEnum: MessageState {
        get { return MessageState(rawValue: state ?? "") ?? .unknown }
            //if let state = state { return MessageState(rawValue: state) ?? .unknown } else { return .unknown } }
        set { state = newValue.rawValue }
    }
}

