//
//  ConversationList.swift
//  Dashing
//
//  Created by Carlo Eugster on 18.05.23.
//

import SwiftUI

struct ConversationList: View {
    @EnvironmentObject var dataController: DataController

    @Binding var selection: UUID?
    var workspaceId: UUID
    
    @State private var isComposing: Bool = false
    
    @FetchRequest var conversations: FetchedResults<Conversation>

    init(forWorkspace: UUID, selection: Binding<UUID?>) {
        workspaceId = forWorkspace
        _selection = selection
        _conversations = FetchRequest<Conversation>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "workspaceId == %@", "\(workspaceId)"),
            animation: .default
        )
    }
        
    var body: some View {
        List(selection: $selection) {
            ForEach(conversations) { conversation in
                ConversationRow(name: conversation.name, lastModified: conversation.modified)
                    .tag(conversation.id)
            }
        }
        .listStyle(.sidebar)
        .listRowSeparator(.visible)
        .sheet(isPresented: $isComposing, content: {
            ComposerView()
        })
        .navigationTitle(navigationTitle)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    isComposing = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .task {
            dataController.updateConversationList(workspaceId: workspaceId)
        }
    }
    
    private var navigationTitle: String {
        guard let conversationId = selection, let conversation = conversations.first(where: { $0.conversationId == conversationId }) else {
            return ""
        }
        return conversation.name
    }

}

struct ConversationRow: View {
    var name: String
    var lastModified: Date
    
    var body: some View {
        HStack {
            HStack {
                EmptyView()
            }
            .frame(width: 44, height: 44)
            .overlay {
                Image("avatar")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
            }
            
            VStack {
                HStack {
                    Text(name)
                        .font(.system(.headline, weight: .bold))
                    Spacer()
                    Text(lastModified, style: .relative)
//                    Text("\(lastModified)")
                        .foregroundColor(.secondary)
                        .font(.system(.caption, weight: .semibold))
                }
                
                Text("Some other text...")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
