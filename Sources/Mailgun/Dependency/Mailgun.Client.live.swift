//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Dependencies
import DependenciesMacros
import Foundation
import MemberwiseInit
import Tagged

extension Mailgun.Client {
    public static func live(
        apiKey: ApiKey,
        baseUrl: URL,
        domain: String,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse)
    ) -> Mailgun.Client {
        
        @Sendable
        func makeRequest(for route: Mailgun.API) throws -> URLRequest {
            @Dependency(\.mailgunRouter) var mailgunRouter
            
            let mailgunAuthenticatedRouter = Mailgun.API.Authenticated.Router(
                baseURL: baseUrl,
                router: mailgunRouter
            )
            
            do {
                let data = try mailgunAuthenticatedRouter.print(.init(apiKey: apiKey.rawValue, route: route))
                
                guard
                    let request = URLRequest(data: data)
                else { throw Error.requestError }
                
                return request
            }
            catch { throw Error.printError }
        }
        
        return Mailgun.Client.init(
            messages: .live(
                apiKey: apiKey,
                baseUrl: baseUrl,
                domain: domain,
                session: session,
                makeRequest: { try makeRequest(for: .messages($0)) }
            ),
            mailingLists: .live(
                apiKey: apiKey,
                baseUrl: baseUrl,
                session: session,
                makeRequest: { try makeRequest(for: .lists($0)) }
            )
        )
    }
}

extension Mailgun.Client {
    enum Error: Swift.Error {
        case printError
        case requestError
    }
}
