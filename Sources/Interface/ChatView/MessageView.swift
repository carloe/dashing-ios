//
//  MessageView.swift
//  Dashing
//
//  Created by Carlo Eugster on 22.05.23.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct MessageView: View {
    var message: MessageModel
    
    @State var lineHeight: CGFloat? = nil
    
    var body: some View {
        HStack {
            if message.sender == .user {
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
                
                Group {
                    switch message.status {
                    case .pending:
                        LoadingIndicator(animation: .threeBallsBouncing, size: .small)
                            .frame(height: lineHeight)
                    case .failed:
                        Text("Failed")
                    case .sent:
                        Text(message.text)
                            .textSelection(.enabled)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background {
                GeometryReader { reader in
                    backgroundColor
                        .clipShape(RoundedRectangle(cornerRadius: (reader.size.height > 44 ? 16 : reader.size.height / 2)))
                }
            }
            
            if message.sender == .assistant {
                renderSpacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: message.sender == .assistant ? .leading : .trailing)
        //.transition(.move(edge: message.sender == .assistant ? .leading : .trailing))
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private var backgroundColor: Color {
        switch message.status {
        case .failed:
            return .red
        case .pending:
            return .gray
        case .sent:
            return message.sender == .assistant ? Color.messageBackground : Color.secondaryMessageBackground
        }
    }
    
    private func renderSpacer() -> some View {
        HStack {
            EmptyView()
        }
        .frame(minWidth: 50)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageView(message:
                            MessageModel(
                                sender: .assistant,
                                status: .sent,
                                text: "Hello World from the assistant"
                            )
            )
            MessageView(message:
                            MessageModel(
                                sender: .user,
                                status: .pending,
                                text: "Hello World from the user!"
                            )
            )
        }
        .padding()
        .frame(maxWidth: 600)
    }
}
