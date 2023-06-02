//
//  DataController.swift
//  Dashing
//
//  Created by Carlo Eugster on 26.05.23.
//

import Foundation
import RealmSwift
import Combine
import Network

// MARK: - Main -

class DataController: ObservableObject {
    let realm: Realm
    let restClient: RESTClientProtocol
    private(set) var socketClient: WebsocketClientProtocol
    let networkMonitor: NetworkMonitor
    
    private var isReachable: Bool = false
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(
        realm: Realm,
        restClient: RESTClientProtocol,
        socketClient: WebsocketClientProtocol,
        networkMonitor: NetworkMonitor
    ) {
        self.restClient = restClient
        self.realm = realm
        self.socketClient = socketClient
        self.networkMonitor = networkMonitor
        self.isReachable = networkMonitor.isConnected
        self.networkMonitor.$isConnected.sink { isReachable in
            if self.isReachable != isReachable {
                print("State changed to \(isReachable ? "Reachable" : "Offline")")
                self.isReachable = isReachable
                self.socketClient.isReachable = isReachable
            }
        }.store(in: &cancellableSet)
    }
}

// MARK: - WebSockets -

extension DataController {
    func startSocket() {
        socketClient.connect { newMessage in
            try! self.realm.write {
                switch newMessage {
                case let .message(model):
                    self.realm.create(Message.self, value: model, update: .modified)
                case let .conversation(model):
                    self.realm.create(Conversation.self, value: model, update: .modified)
                case let .workspace(model):
                    self.realm.create(Conversation.self, value: model, update: .modified)
                }
            }
        }
    }
    
    func stopSocket() {
        socketClient.disconnect()
    }
}

// MARK: - Rest API -

extension DataController {
    func updateWorkspaceList() {
        restClient.fetchWorkspace()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    print("Error: \(dataResponse.error!)")
                } else {
                    guard let newWorkspaces = dataResponse.value else {
                        print("Error: Value was nil eventhough there was no error")
                        return
                    }
                    
                    let oldWorkspaces = self.realm.objects(Workspace.self)
                    let newWorkspaceIDs = Set(newWorkspaces.map { $0.id })
                    let diffWorkspaces = Array(oldWorkspaces.filter { !newWorkspaceIDs.contains($0.id) })
                    
                    try! self.realm.write {
                        self.realm.cascadeDelete(workspaces: diffWorkspaces)
                        for workspace in newWorkspaces {
                            self.realm.create(Workspace.self, value: workspace, update: .modified)
                        }
                    }
                }
            }.store(in: &cancellableSet)
    }
}

extension DataController {
    func updateConversationList(workspaceId: UUID) {
        restClient.fetchConversation(workspaceId: workspaceId)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    print("Error: \(dataResponse.error!)")
                } else {
                    try! self.realm.write {
                        for conversation in dataResponse.value! {
                            self.realm.create(Conversation.self, value: conversation, update: .modified)
                        }
                    }
                }
            }.store(in: &cancellableSet)
    }
}

extension DataController {
    
    func sendMessage(_ content: String, conversationId: UUID) {
        // Create the pending message
        let message = Message()
        message.id = UUID()
        message.conversationId = conversationId
        message.content = content
        message.created = Date()
        message.roleEnum = .user
        message.stateEnum = .pending
        
        try! self.realm.write {
            realm.add(message)
        }
        
        restClient.sendMessage(message)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    print("Error: \(dataResponse.error!)")
                } else {
                    try! self.realm.write {
                        for message in dataResponse.value! {
                            self.realm.create(Message.self, value: message, update: .modified)
                        }
                        self.realm.delete(message)
                    }
                    
                }
            }.store(in: &cancellableSet)
    }
    
    func updateMessageList(conversationId: UUID) {
        restClient.fetchMessages(conversationId: conversationId)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    print("Error: \(dataResponse.error!)")
                } else {
                    try! self.realm.write {
                        for message in dataResponse.value! {
                            self.realm.create(Message.self, value: message, update: .modified)
                        }
                    }
                }
            }.store(in: &cancellableSet)
    }
}
