//
//  PathStore.swift
//  Dashing
//
//  Created by Carlo Eugster on 22.05.23.
//

import SwiftUI

struct StorablePath: Codable {
    var workspaceId: UUID?
    var conversationId: UUID?
    var lastSelected: [UUID: UUID]
}

class PathStore: ObservableObject {
    @Published var workspaceId: UUID? = nil {
        didSet {
            if let workspaceId = workspaceId, let restoredConversationId  = lastSelected[workspaceId] {
                conversationId = restoredConversationId
            }
            else {
                save()
            }
        }
    }
    
    @Published var conversationId: UUID? = nil {
        didSet {
            guard let workspaceId = workspaceId else { return }
            if conversationId == nil {
                lastSelected[workspaceId] = oldValue
            }
            else {
                lastSelected[workspaceId] = conversationId
            }
            save()
        }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedPathStore")
    private var lastSelected: [UUID: UUID] = [:]
    
    func load() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(StorablePath.self, from: data) {
                workspaceId = decoded.workspaceId
                conversationId = decoded.conversationId
                lastSelected = decoded.lastSelected
                return
            }
        }
    }

    func save() {
        let representation = StorablePath(workspaceId: workspaceId, conversationId: conversationId, lastSelected: lastSelected)

        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}
