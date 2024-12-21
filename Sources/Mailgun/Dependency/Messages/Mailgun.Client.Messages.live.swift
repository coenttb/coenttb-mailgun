//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Dependencies
import Foundation
import UrlFormCoding
import Date
import IssueReporting

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Mailgun.Client.Messages {
    public static func live(
        apiKey: Mailgun.Client.ApiKey,
        baseUrl: URL,
        domain: String,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse),
        makeRequest: @escaping @Sendable (_ route: Mailgun.API.Messages) throws -> URLRequest
    ) -> Self {
        
        @Sendable
        func handleRequest<ResponseType: Decodable>(
            for request: URLRequest,
            decodingTo type: ResponseType.Type
        ) async throws -> ResponseType {
            let (data, response) = try await session(request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw MailgunError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw MailgunError.httpError(statusCode: httpResponse.statusCode, message: errorMessage)
            }

            return try JSONDecoder().decode(ResponseType.self, from: data)
        }


        return Self(
            send: { request in
                try await handleRequest(
                    for: makeRequest(.send(domain: domain, request: request)),
                    decodingTo: Mailgun.Messages.Send.Response.self
                )
            },

            sendMime: { request in
                try await handleRequest(
                    for: makeRequest(.sendMime(domain: domain, request: request)),
                    decodingTo: Mailgun.Messages.Send.Response.self
                )
            },

            retrieve: { storageKey in
                try await handleRequest(
                    for: makeRequest(.retrieve(domain: domain, storageKey: storageKey)),
                    decodingTo: Mailgun.Messages.StoredMessage.self
                )
            },

            queueStatus: {
                try await handleRequest(
                    for: makeRequest(.queueStatus(domain: domain)),
                    decodingTo: Mailgun.Messages.Queue.Status.self
                )
            },

            deleteAll: {
                try await handleRequest(
                    for: makeRequest(.deleteScheduled(domain: domain)),
                    decodingTo: Mailgun.Messages.Delete.Response.self
                )
            }
        )
    }
}


