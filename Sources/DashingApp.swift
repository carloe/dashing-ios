//
//  DashingApp.swift
//  Dashing
//
//  Created by Carlo Eugster on 18.05.23.
//

import SwiftUI

@main
struct DashingApp: App {
    @State var themeManager = ThemeManager()
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(dataController)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
