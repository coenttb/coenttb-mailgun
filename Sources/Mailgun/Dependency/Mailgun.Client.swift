//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Dependencies
import DependenciesMacros
import Foundation
import MemberwiseInit
import Tagged

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@DependencyClient
public struct Client: Sendable {
    public let messages: Client.Messages
    public let mailingLists: Client.Lists
    
    public init(messages: Client.Messages, mailingLists: Client.Lists) {
        self.messages = messages
        self.mailingLists = mailingLists
    }
}

extension Mailgun.Client {
    public typealias ApiKey = Tagged<(Self, apiKey: ()), String>
    public typealias Domain = Tagged<(Self, domain: ()), String>
}

extension Mailgun.Client: TestDependencyKey {
    static public let testValue: Client = .init(messages: .testValue, mailingLists: .testValue)
}


extension DependencyValues {
    public var mailgunClient: Mailgun.Client {
        get { self[Mailgun.Client.self] }
        set { self[Mailgun.Client.self] = newValue }
    }
}
