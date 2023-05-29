//
//  MessageModel.swift
//  Dashing
//
//  Created by Carlo Eugster on 22.05.23.
//

import Foundation

extension MessageModel {
    enum Sender: Int {
        case assistant
        case user
    }
    
    enum Status: Int {
        case pending
        case failed
        case sent
    }
}

struct MessageModel: Identifiable {
    let id = UUID()
    var sender: Sender
    var status: Status
    let text: String
}
