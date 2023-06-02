//
//  DashingApp.swift
//  Dashing
//
//  Created by Carlo Eugster on 18.05.23.
//

import SwiftUI
import RealmSwift

@main
struct DashingApp: SwiftUI.App {
    @State var themeManager = ThemeManager()
    
    @StateObject private var dataController: DataController
    
    let realmConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    init() {
        let realm = try! Realm(configuration: realmConfiguration)
        try? realm.removeOrphans()
        let dataController = DataController(
            realm: realm,
            restClient: RESTClient(),
            socketClient: WebsocketClient()
        )
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(dataController)
                .environment(\.realmConfiguration, realmConfiguration)
        }
    }
}

