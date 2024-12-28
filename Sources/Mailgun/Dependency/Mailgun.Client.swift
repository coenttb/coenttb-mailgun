//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import CoenttbWeb
import Tagged
import DependenciesMacros
import Credentials
import CustomMessageLimit
import Domains
import Events
import IPAllowlist
import IPPools
import IPs
import Keys
import Lists
import Messages
import Reporting
import Routes
import Subaccounts
import Suppressions
import Tags
import Templates
import Users
import Webhooks

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@DependencyClient
public struct Client: Sendable {
    public let messages: Messages.Client
    public let mailingLists: Lists.Client
    public let events: Events.Client
    public let suppressions: Suppressions.Client
    public let webhooks: Webhooks.Client
    
    public init(messages: Messages.Client, mailingLists: Lists.Client, events: Events.Client, suppressions: Suppressions.Client, webhooks: Webhooks.Client) {
        self.messages = messages
        self.mailingLists = mailingLists
        self.events = events
        self.suppressions = suppressions
        self.webhooks = webhooks
    }
}

extension Mailgun.Client: TestDependencyKey {
    static public let testValue: Client? = .init(
        messages: .testValue,
        mailingLists: .testValue,
        events: { fatalError() }(),
        suppressions: { fatalError() }(),
        webhooks: { fatalError() }()
    )
}

extension DependencyValues {
    public var mailgunClient: Mailgun.Client? {
        get { self[Mailgun.Client.self] }
        set { self[Mailgun.Client.self] = newValue }
    }
}