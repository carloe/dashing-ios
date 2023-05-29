//
//  ComposerView.swift
//  Dashing
//
//  Created by Carlo Eugster on 22.05.23.
//

import SwiftUI

struct ComposerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var text: String = ""
    
    @State private var buttonHeight: CGFloat? = nil
    
    var body: some View {
        NavigationStack {
            HStack {
                TextField("Search for someone...", text: $text)
                    .textFieldStyle(.plain)
                    .frame(height: buttonHeight)
                    .background {
                        GeometryReader { reader in
                            Color.clear
                                .onAppear {
                                    buttonHeight = reader.size.height
                                }
                        }
                    }
                
                Button(action: {
                    print("Cancel")
                }, label: {
                    Image(systemName: "plus")
                        .bold()
                        .padding(4)
                })
                .frame(height: buttonHeight)
                .buttonStyle(CircleButtonStyle())
            }
            .padding()
            .frame(minWidth: 400, minHeight: 44)
            .navigationTitle("New Chat")
        }
    }
}

struct ComposerView_Previews: PreviewProvider {
    static var previews: some View {
        ComposerView()
    }
}
