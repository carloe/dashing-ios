//
//  DataController.swift
//  Dashing
//
//  Created by Carlo Eugster on 26.05.23.
//

import Foundation
import CoreData
import Combine

class DataController: ObservableObject {
    let container: NSPersistentContainer // = NSPersistentContainer(name: "Schema")
    var context: NSManagedObjectContext {
        
        return container.viewContext
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    let apiService: ServiceProtocol
    
    init(container: NSPersistentContainer = NSPersistentContainer(name: "Schema")) {
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.container = container
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = container.viewContext
        self.apiService = Service(decoder: decoder)
        
        self.container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
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
                    for workspaceItem in dataResponse.value! {
                        print("\(workspaceItem)")
                        //self.createOrUpdate(workspaceItem)
                    }
                    //try? self.container.viewContext.save()
                }
            }.store(in: &cancellableSet)
    }
    
//    private func createOrUpdate(_ model: WorkspaceResponse) {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Workspace")
//        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(model.id)")
//        guard let fetchRresults = try? self.context.fetch(fetchRequest) else {
//            print("No response... handle error")
//            return
//        }
//        let workspace: Workspace!
//        workspace = (fetchRresults.count == 0) ? Workspace(context: self.context) : fetchRresults.first as! Workspace
//        workspace.id = model.id
//        workspace.name = model.name
//    }
}


extension DataController {
    func updateConversationList(workspaceId: UUID) {
        apiService.fetchConversation(workspaceId: workspaceId)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    print("Error: \(dataResponse.error!)")
                } else {
                    for conversationItem in dataResponse.value! {
                        print("\(conversationItem)")
                        //self.createOrUpdate(conversationItem)
                    }
                    try? self.container.viewContext.save()
                }
            }.store(in: &cancellableSet)
    }
    
//    private func createOrUpdate(_ model: ConversationResponse) {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Conversation")
//        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(model.id)")
//        guard let fetchRresults = try? self.context.fetch(fetchRequest) else {
//            print("No response... handle error")
//            return
//        }
//        let conversation: Conversation!
//        conversation = (fetchRresults.count == 0) ? Conversation(context: self.context) : fetchRresults.first as! Conversation
//        conversation.id = model.id
//        conversation.name = model.name
//        conversation.workspaceId = model.workspaceId
//    }
}
