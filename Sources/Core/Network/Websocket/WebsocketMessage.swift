//
//  WebsocketMessage.swift
//  Dashing
//
//  Created by Carlo Eugster on 02.06.23.
//

import Foundation

enum WebsocketMessage {
    case workspace(Workspace)
    case message(Message)
    case conversation(Conversation)
}
