//
//  WorkspaceListRow.swift
//  Dashing
//
//  Created by Carlo Eugster on 28.05.23.
//

import SwiftUI

struct WorkspaceListRow: View {
    var model: Workspace
    
    var body: some View {
        Label {
            Text("\(model.name)")
        } icon: {
            Image(systemName: "paperplane")
        }
    }
}

//struct WorkspaceListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspaceListRow()
//    }
//}
