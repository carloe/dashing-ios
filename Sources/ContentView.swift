//
//  ContentView.swift
//  Dashing
//
//  Created by Carlo Eugster on 18.05.23.
//

import SwiftUI
import Combine

struct Context: Identifiable {
    var id: Int
    var title: String
}



struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    
    @StateObject private var pathStore = PathStore()
    
    var body: some View {
        NavigationSplitView {
            WorkspaceList(selected: $pathStore.workspaceId)
                .navigationTitle("Workspace")
        } content: {
            if pathStore.workspaceId != nil {
                ConversationList(
                    forWorkspace: pathStore.workspaceId!,
                    selection: $pathStore.conversationId
                )
            }
            else {
                Text("Select a Workspace")
            }
        } detail: {
            Group {
                if pathStore.conversationId != nil {
                    ChatView(conversationId: pathStore.conversationId!)
                }
                else {
                    Text("Empty View")
                }
            }
            .navigationTitle("Coffee")
        }
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
