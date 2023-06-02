//
//  DataCleanup.swift
//  Dashing
//
//  Created by Carlo Eugster on 31.05.23.
//

import Foundation
import RealmSwift

extension Realm {
    func removeOrphans() throws {
        let workspaces = self.objects(Workspace.self)
        let workspaceIDs = Set(workspaces.map { $0.id })
        
        let conversations = self.objects(Conversation.self)
        let removedConversations = conversations.filter { !workspaceIDs.contains($0.workspaceId) }
        let conversationIDs = Set(removedConversations.map { $0.id })
        
        let messages = self.objects(Message.self)
        let removedMessages = messages.filter { conversationIDs.contains($0.conversationId) }
        
        try self.write {
            for message in removedMessages {
                self.delete(message)
            }
            for conversation in removedConversations {
                self.delete(conversation)
            }
        }
    }
}

extension Realm {
    func cascadeDelete(workspaces: [Workspace]) {
        for workspace in workspaces {
            self.cascadeDelete(workspace: workspace)
        }
    }
    
    func cascadeDelete(workspace: Workspace) {
        let conversations = self.objects(Conversation.self).where {
            $0.workspaceId == workspace.id
        }
        cascadeDelete(conversations: conversations)
        self.delete(workspace)
    }
}

extension Realm {
    func cascadeDelete(conversations: Results<Conversation>) {
        for conversation in conversations {
            self.cascadeDelete(conversation: conversation)
        }
    }
    
    func cascadeDelete(conversation: Conversation) {
        let messages = self.objects(Message.self).where {
            $0.conversationId == conversation.id
        }
        cascadeDelete(messages: messages)
        self.delete(conversation)
    }
}

extension Realm {
    func cascadeDelete(messages: Results<Message>) {
        for message in messages {
            self.cascadeDelete(message: message)
        }
    }
    
    func cascadeDelete(message: Message) {
        self.delete(message)
    }
}
