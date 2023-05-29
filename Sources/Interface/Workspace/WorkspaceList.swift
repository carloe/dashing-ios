//
//  WorkspaceList.swift
//  Dashing
//
//  Created by Carlo Eugster on 28.05.23.
//

import SwiftUI

struct WorkspaceList: View {
    @Binding var selected: UUID?
    
    @FetchRequest(
        sortDescriptors: [
//            SortDescriptor(Workspace.name)
        ]
    ) var workspaces: FetchedResults<Workspace>
    
    var body: some View {
        List(selection: $selected) {
            ForEach(workspaces) { workspace in
                WorkspaceListRow(model: workspace)
            }
        }
    }
}

//struct WorkspaceList_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspaceList()
//    }
//}
