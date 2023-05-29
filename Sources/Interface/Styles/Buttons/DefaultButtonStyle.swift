//
//  DefaultButtonStyle.swift
//  Dashing
//
//  Created by Carlo Eugster on 22.05.23.
//

import SwiftUI

struct DefaultButtonStyle: ButtonStyle {
    
    var cornerRadius: CGFloat = 8
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.accentColor)
            }
    }
}

struct DefaultButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Hello") {
            print("world")
        }
        .buttonStyle(DefaultButtonStyle())
    }
}
