//
//  MessageView.swift
//  Dashing
//
//  Created by Carlo Eugster on 22.05.23.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct MessageView: View {
    var message: Message
    
    @State var lineHeight: CGFloat? = nil
    
    @ViewBuilder
    private func renderOverlay() -> some View {
            switch message.statusEnum {
            case .final, .pending, .unknown:
                EmptyView()
            case .error:
                Text("Failed")
            }
    }
    
    private var opacity: CGFloat {
        switch message.statusEnum {
        case .pending, .unknown:
            return 0.5
        case .error, .final:
            return 1
        }
    }
    
    var body: some View {
        HStack {
            if message.roleEnum == .user {
                renderSpacer()
            }
            
            ZStack {
                // Measure single line height
                Text("ji")
                    .background {
                        GeometryReader { reader in
                            Color.clear
                                .onAppear {
                                    lineHeight = reader.size.height
                                }
                        }
                        
                    }
                    .opacity(0)
                
                Text(message.content)
                    .textSelection(.enabled)
            }
            .frame(alignment: .bottomTrailing)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background {
                GeometryReader { reader in
                    backgroundColor
                        .clipShape(RoundedRectangle(cornerRadius: (reader.size.height > 44 ? 16 : reader.size.height / 2)))
                }
            }
            .opacity(opacity)
            .overlay {
                renderOverlay()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .offset(x: 4, y: 4)
            }
            
            if message.roleEnum != .user {
                renderSpacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: message.roleEnum != .user ? .trailing : .leading)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    
    private var backgroundColor: Color {
         switch message.statusEnum {
         case .error:
             return .red
         case .pending, .unknown:
             return .gray
         case .final:
             return message.roleEnum != .user ? Color.secondaryMessageBackground : Color.messageBackground
         }
    }
    
    private func renderSpacer() -> some View {
        HStack {
            EmptyView()
        }
        .frame(minWidth: 50, maxWidth: .infinity)
    }
}
