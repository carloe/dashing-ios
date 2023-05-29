//
//  CircleButtonStyle.swift
//  Dashing
//
//  Created by Carlo Eugster on 22.05.23.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {
    
    var fillColor: Color = .accentColor
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                Circle()
                    .fill(fillColor)
            }
    }
}

struct CircleButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {
            print("tap, tap!")
        }, label: {
            Image(systemName: "paperplane")
                .bold()
                .padding()
        })
        .buttonStyle(DefaultButtonStyle())
    }
}
