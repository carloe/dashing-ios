//
//  ConversationResponse.swift
//  Dashing
//
//  Created by Carlo Eugster on 28.05.23.
//

import Foundation

struct ConversationResponse: Codable {
    var id: UUID
    var name: String
    var workspaceId: UUID
    var created: Date
    var modified: Date
}
