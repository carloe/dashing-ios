//
//  DefaultTheme.swift
//  Dashing
//
//  Created by Carlo Eugster on 22.05.23.
//

import SwiftUI

struct DefaultTheme: Theme {
    
    var chatBackground: Color {
#if os(iOS) || os(watchOS) || os(tvOS)
        return Color(uiColor: UIColor.systemGroupedBackground)
#elseif os(macOS)
        return Color(NSColor.textBackgroundColor)
#endif
    }
    
    var messageBackground: Color {
#if os(iOS) || os(watchOS) || os(tvOS)
        return Color(uiColor: UIColor.tertiarySystemFill)
#elseif os(macOS)
        return Color(NSColor.windowBackgroundColor)
#endif
    }
    
    var secondaryMessageBackground: Color {
#if os(iOS) || os(watchOS) || os(tvOS)
        return Color.accentColor
#elseif os(macOS)
        return Color(NSColor.controlAccentColor)
#endif
    }
}
