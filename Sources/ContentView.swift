//
//  ContentView.swift
//  Dashing
//
//  Created by Carlo Eugster on 18.05.23.
//

import SwiftUI
import Combine


struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    
    @StateObject private var pathStore = PathStore()
    @State var splitViewVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $splitViewVisibility) {
            WorkspaceList(selected: $pathStore.workspaceId)
                .navigationTitle("Workspace")
        } content: {
            if let workspaceId = pathStore.workspaceId {
                ConversationList(
                    forWorkspace: workspaceId,
                    selection: $pathStore.conversationId
                )
            }
            else {
                Text("Select a Workspace")
            }
        } detail: {
            if let conversationId = pathStore.conversationId {
                ChatView(conversationId: conversationId)
            }
            else {
                Text("Select a Conversation")
            }
        }
        .navigationSplitViewStyle(.balanced)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    print("Show search")
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
        .task {
            pathStore.load()
            dataController.updateWorkspaceList()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(maxWidth: 480)
    }
}
