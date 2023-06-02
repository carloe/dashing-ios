//
//  RESTClientProtocol.swift
//  Dashing
//
//  Created by Carlo Eugster on 02.06.23.
//

import Foundation
import Alamofire
import Combine

protocol RESTClientProtocol {
    func fetchWorkspace() -> AnyPublisher<DataResponse<[Workspace], NetworkError>, Never>
    func fetchConversation(workspaceId: UUID) -> AnyPublisher<DataResponse<[Conversation], NetworkError>, Never>
    func fetchMessages(conversationId: UUID) -> AnyPublisher<DataResponse<[Message], NetworkError>, Never>
    func sendMessage(_ message: Message) -> AnyPublisher<DataResponse<[Message], NetworkError>, Never>
}
