//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Foundation
import URLRouting
import BasicAuth

extension Mailgun.API {
    struct Authenticated {
        let basicAuth: BasicAuth
        let route: Mailgun.API
        
        public init(basicAuth: BasicAuth, route: Mailgun.API) {
            self.basicAuth = basicAuth
            self.route = route
        }
        
        public init(apiKey: String, route: Mailgun.API) {
            self.basicAuth = .init(username: "api", password: apiKey)
            self.route = route
        }
    }
}

extension Mailgun.API.Authenticated {
    public struct Router: ParserPrinter, Sendable {
        
        let baseURL: URL
        let router: Mailgun.API.Router
        
        public init(
            baseURL: URL,
            router: Mailgun.API.Router
        ) {
            self.baseURL = baseURL
            self.router = router
        }
        
        
        public var body: some URLRouting.Router<Mailgun.API.Authenticated> {
            Parse(.memberwise(Mailgun.API.Authenticated.init)) {
                
                BasicAuth.Router()
                
                router
            }
            .baseURL(self.baseURL.absoluteString)
        }
    }
}
