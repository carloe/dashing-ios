//
//  APIService.swift
//  Dashing
//
//  Created by Carlo Eugster on 28.05.23.
//

import Foundation
import Combine
import Alamofire

class RESTClient {
    let decoder: JSONDecoder
    let baseURL: URL
    
    init(
        url: URL,
        decoder: JSONDecoder? = nil
    ) {
        self.baseURL = url
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
    }
}


extension RESTClient: RESTClientProtocol {
    func fetchWorkspace() -> AnyPublisher<DataResponse<[Workspace], NetworkError>, Never> {
        let url = self.baseURL.appendingPathComponent("/workspaces/")
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
        let url = self.baseURL.appendingPathComponent("/conversations/")
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
        let url = self.baseURL.appendingPathComponent("/messages/")
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
    
    func sendMessage(_ message: Message) -> AnyPublisher<DataResponse<[Message], NetworkError>, Never> {
        let url = self.baseURL.appendingPathComponent("/messages/")
        let parameters: [String: Any] = [
            "conversation_id": message.conversationId.uuidString,
            "content": message.content,
            "role": message.role
        ]
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
