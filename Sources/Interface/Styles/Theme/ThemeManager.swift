//
//  ThemeManager.swift
//  Dashing
//
//  Created by Carlo Eugster on 22.05.23.
//

import Foundation


class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var activeTheme: any Theme = DefaultTheme()
}
