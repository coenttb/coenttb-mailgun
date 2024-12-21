//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Dependencies
import Foundation
import UrlFormCoding
import URLRouting

extension Mailgun.API {
    public enum Messages: Equatable, Sendable {
        case send(domain: String, request: Mailgun.Messages.Send.Request)
        case sendMime(domain: String, request: Mailgun.Messages.Send.Mime.Request)
        case retrieve(domain: String, storageKey: String)
        case queueStatus(domain: String)
        case deleteScheduled(domain: String)
    }
}

extension Mailgun.API.Messages {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<Mailgun.API.Messages> {
            OneOf {
                // POST /v3/{domain_name}/messages
                Route(.case(Mailgun.API.Messages.send)) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string) }
                    Path { "messages" }
                    Body(.form(Mailgun.Messages.Send.Request.self, decoder: .default))
                }
                
                // POST /v3/{domain_name}/messages.mime
                Route(.case(Mailgun.API.Messages.sendMime)) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string) }
                    Path { "messages.mime" }
                    Body(.form(Mailgun.Messages.Send.Mime.Request.self, decoder: .default))
                }
                
                // GET /v3/domains/{domain_name}/messages/{storage_key}
                Route(.case(Mailgun.API.Messages.retrieve)) {
                    Method.get
                    Path { "v3" }
                    Path { "domains" }
                    Path { Parse(.string) }
                    Path { "messages" }
                    Path { Parse(.string) }
                }
                
                // GET /v3/domains/{name}/sending_queues
                Route(.case(Mailgun.API.Messages.queueStatus)) {
                    Method.get
                    Path { "v3" }
                    Path { "domains" }
                    Path { Parse(.string) }
                    Path { "sending_queues" }
                }
                
                // DELETE /v3/{domain_name}/envelopes
                Route(.case(Mailgun.API.Messages.deleteScheduled)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string) }
                    Path { "envelopes" }
                }
            }
        }
    }
}

extension UrlFormDecoder {
    fileprivate static var `default`: UrlFormDecoder {
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        return decoder
    }
}
