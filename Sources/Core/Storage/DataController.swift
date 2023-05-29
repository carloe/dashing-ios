//
//  DataController.swift
//  Dashing
//
//  Created by Carlo Eugster on 26.05.23.
//

import Foundation
import RealmSwift
import Combine

class DataController: ObservableObject {
    
    private var cancellableSet: Set<AnyCancellable> = []
    let apiService: ServiceProtocol
    let realm: Realm
    
    init(realm: Realm = try! Realm()) {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(formatter)
        self.apiService = Service(decoder: decoder)
        self.realm = realm
    }
}

extension DataController {
    
}

extension DataController {
    func updateWorkspaceList() {
        apiService.fetchWorkspace()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    print("Error: \(dataResponse.error!)")
                } else {
                    try! self.realm.write {
                        for workspace in dataResponse.value! {
                            self.realm.create(Workspace.self, value: workspace, update: .modified)
                        }
                    }
                }
            }.store(in: &cancellableSet)
    }
}

extension DataController {
    func updateConversationList(workspaceId: UUID) {
        apiService.fetchConversation(workspaceId: workspaceId)
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
    func updateMessageList(conversationId: UUID) {
        apiService.fetchMessages(conversationId: conversationId)
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
