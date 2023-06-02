//
//  WebsocketClient.swift
//  Dashing
//
//  Created by Carlo Eugster on 02.06.23.
//

import Foundation

protocol WebsocketClientProtocol {
    
    var isConnected: Bool { get }
    var isReachable: Bool { get set }
    
    func connect(onMessage: @escaping ((WebsocketMessage) -> Void))
    func disconnect()
    func sendMessage(message: String)
    func ping()
}

