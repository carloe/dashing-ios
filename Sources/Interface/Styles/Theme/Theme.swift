//
//  ThemeColors.swift
//  Dashing
//
//  Created by Carlo Eugster on 22.05.23.
//

import SwiftUI

protocol Theme: Equatable {
    var chatBackground: Color { get }
    var messageBackground: Color { get }
    var secondaryMessageBackground: Color { get }
}
