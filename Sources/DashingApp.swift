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
    @State var settings: Settings
    
    @StateObject private var dataController: DataController
    @StateObject private var networkMonitor: NetworkMonitor
    
    let realmConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    init() {
        let settings = Settings()
        _settings = State(wrappedValue: settings)
        
        let networkMonitor = NetworkMonitor()
        _networkMonitor = StateObject(wrappedValue: networkMonitor)
        
        let realm = try! Realm(configuration: realmConfiguration)
        try? realm.removeOrphans()
        let dataController = DataController(
            realm: realm,
            restClient: RESTClient(url: settings.restURL()),
            socketClient: WebsocketClient(url: settings.socketURL()),
            networkMonitor: networkMonitor
        )
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(dataController)
                .environmentObject(networkMonitor)
                .environment(\.realmConfiguration, realmConfiguration)
                .onAppear {
                    networkMonitor.start()
                }
                .onDisappear {
                    networkMonitor.stop()
                }
        }
    }
}

