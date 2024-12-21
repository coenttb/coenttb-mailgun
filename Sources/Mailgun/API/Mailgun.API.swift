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

public enum MailgunRouterKey: TestDependencyKey {
    public static var testValue: Mailgun.API.Router {
        return .init()
    }
}

extension DependencyValues {
    public var mailgunRouter: Mailgun.API.Router {
        get { self[MailgunRouterKey.self] }
        set { self[MailgunRouterKey.self] = newValue }
    }
}

public enum API: Equatable, Sendable {
    case messages(Mailgun.API.Messages)
    case lists(Mailgun.API.Lists)
}



extension Mailgun.API {
    public struct Router: ParserPrinter, Sendable {
        
        public var body: some URLRouting.Router<Mailgun.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.API.messages)) {
                    Mailgun.API.Messages.Router()
                }
                
                URLRouting.Route(.case(Mailgun.API.lists)) {
                    Mailgun.API.Lists.Router()
                }
            }
        }
    }
}

