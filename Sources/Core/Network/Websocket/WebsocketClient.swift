//
//  WebsocketService.swift
//  Dashing
//
//  Created by Carlo Eugster on 31.05.23.
//

import Foundation
import RealmSwift
import Combine

class WebsocketClient: NSObject {
    
    let url: URL
    let decoder: JSONDecoder

    private var onMessage: ((WebsocketMessage) -> Void)?
    private var socketConnection: URLSessionWebSocketTask? = nil
    
    private(set) var autoconnectOnReachable: Bool = false
    private(set) var isConnected = false
    var isReachable: Bool = false {
        didSet {
            self.reconnectIfNeeded()
        }
    }
    
    init(
        url: URL,
        decoder: JSONDecoder? = nil
    ) {
        if let decoder = decoder {
            self.decoder = decoder
        }
        else {
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(formatter)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.decoder = decoder
        }
        self.url = url
    }
    
    private func reconnectIfNeeded() {
        if !autoconnectOnReachable || isConnected { return }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        self.socketConnection = session.webSocketTask(with: url)
        setReceiveHandler()
        socketConnection?.resume()
    }
    
    private func setReceiveHandler() {
        socketConnection?.receive { [weak self] result in
            defer { self?.setReceiveHandler() }
            
            if self?.isConnected == false { return }
            
            switch result {
            case let .failure(error):
                print("Receive error: \(error)")
                self?.isConnected = false
                DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                    self?.reconnectIfNeeded()
                }
            case let .success(.string(string)):
                DispatchQueue.main.async {
                    let jsonData = string.data(using: .utf8)!
                    self?.decodeAndNotify(jsonData)
                }
            case let .success(.data(jsonData)):
                DispatchQueue.main.async {
                    self?.decodeAndNotify(jsonData)
                }
            default:
                print("Error: Got non string message :(")
            }
        }
    }
    
    private func decodeAndNotify(_ jsonData: Data) {
        if let model = try? self.decoder.decode(Message.self, from: jsonData) {
            self.onMessage?(.message(model))
            return
        }
        else if let model = try? self.decoder.decode(Conversation.self, from: jsonData) {
            self.onMessage?(.conversation(model))
            return
        }
        else if let model = try? self.decoder.decode(Workspace.self, from: jsonData) {
            self.onMessage?(.workspace(model))
            return
        }
        else if let string = String(data: jsonData, encoding: .utf8) {
            if ["ping", "connected"].contains(string.lowercased())  {
                return
            }
        }
        print("Error: Do not know the type of '\(jsonData)'")
    }
}

extension WebsocketClient: URLSessionWebSocketDelegate{
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web Socket did connect")
        isConnected = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            self.ping()
        }
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect: \(closeCode)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("didCompleteWithError: \(error)")
            isConnected = false
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                self.reconnectIfNeeded()
            }
        }
    }
}

extension WebsocketClient: WebsocketClientProtocol {
    func connect(onMessage: @escaping ((WebsocketMessage) -> Void)) {
        self.autoconnectOnReachable = true
        self.onMessage = onMessage
        self.reconnectIfNeeded()
    }
    
    func disconnect() {
        self.autoconnectOnReachable = false
        let reason = "Closing connection".data(using: .utf8)
        self.socketConnection?.cancel(with: .goingAway, reason: reason)
    }
    
    func sendMessage(message: String) {
        socketConnection?.send(.string(message)) { error in
            if let error = error {
                print("\(error)")
            }
            else {
                print("Success!")
            }
        }
    }
    
    func ping() {
        //if self.isConnected == false { return }
        self.socketConnection?.sendPing { [weak self] error in
            if let error = error {
                print("Error when sending PING \(error)")
            } else {
                print("Web Socket connection is alive")
                DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                    self?.ping()
                }
            }
        }
    }
}
