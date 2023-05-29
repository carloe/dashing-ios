//
//  Workspace.swift
//  Dashing
//
//  Created by Carlo Eugster on 28.05.23.
//


import Foundation
import CoreData


class Conversation: NSManagedObject, BaseModel {
    
    var id: UUID {
        return conversationId
    }
    
    @NSManaged var conversationId: UUID
    @NSManaged var name: String
    @NSManaged var workspaceId: UUID
    @NSManaged var modified: Date
    @NSManaged var created: Date
    
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case workspaceId
        case modified
        case created
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Conversation", in: context) else {
            throw DecoderConfigurationError.missingEntity
        }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.conversationId = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.workspaceId = try container.decode(UUID.self, forKey: .workspaceId)
        self.modified = try container.decode(Date.self, forKey: .modified)
        self.created = try container.decode(Date.self, forKey: .created)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(conversationId, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(workspaceId, forKey: .workspaceId)
        try container.encode(modified, forKey: .modified)
        try container.encode(created, forKey: .created)
    }
}
