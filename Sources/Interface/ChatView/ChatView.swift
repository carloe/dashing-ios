//
//  ChatView.swift
//  Dashing
//
//  Created by Carlo Eugster on 22.05.23.
//

import SwiftUI
import RealmSwift

struct ChatView: View {
    @EnvironmentObject var dataController: DataController
    
    //@State var messages: [MessageModel] = []
    @State var draftMessage: String = ""
    @State var showHeader: Bool = false
    
    let conversationId: UUID
    
    @ObservedResults(Message.self) var messages
    
    init(conversationId: UUID) {
        self.conversationId = conversationId
        _messages = ObservedResults(Message.self, where: {
            $0.conversationId == conversationId
        })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if showHeader {
                VStack {
                    Text("Foo")
                }
                .frame(maxHeight: .infinity)
            }
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 12) {
                        ForEach(messages) { model in
                            MessageView(message: model)
                                .id(model.id)
                        }
                        .onChange(of: messages.count) { _ in
                            scrollToLastMessage(in: proxy)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    if messages.isEmpty {
                        VStack {
                            Image("empty_messageView")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 120, maxHeight: 120)
                            
                            Text("No Messages")
                        }
                        .transition(.move(edge: .top).combined(with: .opacity).animation(.easeInOut))
                    }
                }
            }
            .background(Color.chatBackground)
            
            Divider()
            
            ChatInputView(text: $draftMessage) { text in
                let message = MessageModel(
                    sender: .user,
                    status: .pending,
                    text: text
                )
//                withAnimation {
//                    messages.append(message)
//                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
        }
        .navigationTitle("Chat")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    withAnimation(.easeInOut) {
                        showHeader.toggle()
                    }
                } label: {
                    Image(systemName: "slider.vertical.3")
                }
            }
        }
        .task {
            dataController.updateMessageList(conversationId: conversationId)
        }
    }
    
    private func scrollToLastMessage(in reader: ScrollViewProxy) {
        guard let lastMessage = messages.last else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            reader.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}

/*
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
*/
