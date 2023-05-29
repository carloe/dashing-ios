//
//  Color+Theme.swift
//  Dashing
//
//  Created by Carlo Eugster on 22.05.23.
//

import SwiftUI

extension Color {
    static var themeManager: ThemeManager {
        return ThemeManager.shared
    }
    
    static var chatBackground: Color {
        return themeManager.activeTheme.chatBackground
    }
    
    static var messageBackground: Color {
        return themeManager.activeTheme.messageBackground
    }
    
    static var secondaryMessageBackground: Color {
        return themeManager.activeTheme.secondaryMessageBackground
    }
}
