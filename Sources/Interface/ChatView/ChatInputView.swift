//
//  ChatInputView.swift
//  Dashing
//
//  Created by Carlo Eugster on 22.05.23.
//

import SwiftUI

struct ChatInputView: View {
    @Binding var text: String
    
    @State private var expanded: Bool =  false
    
    @State private var textFieldHeight: CGFloat? = nil
    @State private var cornerRadius: CGFloat? = nil
    
    @FocusState private var inputIsFocused: Bool

    
    var onSend: ((String) -> Void)
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            
            Button(action: {
                withAnimation(.easeInOut) {
                    expanded.toggle()
                }
            }, label: {
                ZStack {
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(expanded ? 90 : 0))
                        .bold()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            })
            .foregroundColor(.secondary)
            .padding(3)
            .frame(width: buttonSize, height: buttonSize, alignment: .center)
            .buttonStyle(.plain)
            .transition(.opacity)
            
            HStack(alignment: .bottom) {
                TextField("Send a Message", text: $text, axis: .vertical)
                    .focused($inputIsFocused)
                    .onSubmit {
                        if expanded {
                            
                        }
                        handleSubmit()
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .multilineTextAlignment(.leading)
                    .lineLimit(8, reservesSpace: expanded)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                if !text.isEmpty {
                    Button(action: {
                        handleSubmit()
                    }, label: {
                        ZStack {
                            Image(systemName: "arrow.up")
                                .bold()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    })
                    .foregroundColor(.secondary)
                    .padding(3)
                    .frame(width: buttonSize, height: buttonSize, alignment: .center)
                    .buttonStyle(CircleButtonStyle())
                    .transition(.opacity)
                }
            }
            .background {
                GeometryReader { reader in
                    RoundedRectangle(cornerRadius: cornerRadius ?? 8)
                        .fill(barBackgroundColor)
                        .onAppear {
                            textFieldHeight = reader.size.height
                            cornerRadius = reader.size.height / 2
                        }
                }
            }
        }
        .onAppear {
            inputIsFocused = true
        }
    }
    
    private var buttonSize: CGFloat? {
        guard let textFieldHeight = textFieldHeight else { return nil }
        return textFieldHeight
    }
    
    private func handleSubmit() {
        let messageText = text
        text = ""
        onSend(messageText)
    }
    
    private var barBackgroundColor: Color {
#if os(iOS) || os(watchOS) || os(tvOS)
        return Color(uiColor: UIColor.tertiarySystemBackground)
#elseif os(macOS)
        return Color(nsColor: NSColor.textBackgroundColor)
#endif
    }
}

// MARK: Previews

struct ChatInputView_Previews: PreviewProvider {
    struct DemoView: View {
        @State var draft: String = ""
        
        var body: some View {
            ChatInputView(text: $draft, onSend: { text in
                print("Send: \(text)")
            })
        }
    }
    
    static var previews: some View {
        DemoView()
    }
}
