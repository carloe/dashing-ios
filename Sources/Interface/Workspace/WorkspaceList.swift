//
//  WorkspaceList.swift
//  Dashing
//
//  Created by Carlo Eugster on 28.05.23.
//

import SwiftUI
import RealmSwift

struct WorkspaceList: View {
    @Binding var selected: UUID?
    
    @ObservedResults(Workspace.self) var workspaces
    
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
