//
//  Settings.swift
//  Dashing
//
//  Created by Carlo Eugster on 02.06.23.
//

import Foundation


struct Settings: Codable {
    
    var apiHost: String = "avalon.carlo.io"
    var apiPort: Int? = nil
    
    var restSchema: String = "https"
    var restPath: String = "/api"

    var socketSchema: String = "wss"
    var socketPath: String = "/api/ws"
    
    func restURL() -> URL {
        var components = URLComponents()
        components.scheme = restSchema
        components.host = apiHost
        components.path = restPath
        if let port = apiPort {
            components.port = port
        }
        return components.url!
    }
    
    func socketURL() -> URL {
        var components = URLComponents()
        components.scheme = socketSchema
        components.host = apiHost
        components.path = socketPath
        if let port = apiPort {
            components.port = port
        }
        return components.url!
    }
}
