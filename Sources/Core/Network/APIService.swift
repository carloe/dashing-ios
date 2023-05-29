//
//  APIService.swift
//  Dashing
//
//  Created by Carlo Eugster on 28.05.23.
//

import Foundation
import Combine
import Alamofire

protocol ServiceProtocol {
    func fetchWorkspace() -> AnyPublisher<DataResponse<[Workspace], NetworkError>, Never>
    func fetchConversation(workspaceId: UUID) -> AnyPublisher<DataResponse<[Conversation], NetworkError>, Never>
    func fetchMessages(conversationId: UUID) -> AnyPublisher<DataResponse<[Message], NetworkError>, Never>
}

class Service {
    //static let shared: ServiceProtocol = Service()
    let decoder: JSONDecoder
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
}


extension Service: ServiceProtocol {
    func fetchWorkspace() -> AnyPublisher<DataResponse<[Workspace], NetworkError>, Never> {
        let url = URL(string: "https://avalon.carlo.io/api/workspaces/")!
        
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: [Workspace].self, decoder: self.decoder)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? self.decoder.decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchConversation(workspaceId: UUID) -> AnyPublisher<DataResponse<[Conversation], NetworkError>, Never> {
        let url = URL(string: "https://avalon.carlo.io/api/conversations/")!
        
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: [Conversation].self, decoder: self.decoder)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? self.decoder.decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchMessages(conversationId: UUID) -> AnyPublisher<DataResponse<[Message], NetworkError>, Never> {
        let url = URL(string: "https://avalon.carlo.io/api/messages/")!
        
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: [Message].self, decoder: self.decoder)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? self.decoder.decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
