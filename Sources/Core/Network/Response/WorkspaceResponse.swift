//
//  WorkspaceResponse.swift
//  Dashing
//
//  Created by Carlo Eugster on 28.05.23.
//

import Foundation

struct WorkspaceResponse: Codable {
    var id: UUID
    var name: String
    var created: Date
    var modified: Date
}
