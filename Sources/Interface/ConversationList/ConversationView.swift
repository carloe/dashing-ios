//
//  ConversationView.swift
//  Dashing
//
//  Created by Carlo Eugster on 22.05.23.
//

import SwiftUI

struct ConversationView: View {
    @State private var isComposing: Bool = false
    
    var body: some View {
        ChatView()
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        print("settings")
                    } label: {
                        Image(systemName: "slider.vertical.3")
                    }
                }
                
                ToolbarItem(placement: .automatic) {
                    Button {
                        print("Info")
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView()
    }
}
