//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Dependencies
import DependenciesMacros

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Client {
    @DependencyClient
    public struct Messages: Sendable {
        /// Sends an email by providing individual components
        @DependencyEndpoint
        public var send: @Sendable (_ request: Mailgun.Messages.Send.Request) async throws -> Mailgun.Messages.Send.Response
        
        /// Sends an email using MIME format
        @DependencyEndpoint
        public var sendMime: @Sendable (_ request: Mailgun.Messages.Send.Mime.Request) async throws -> Mailgun.Messages.Send.Response
        
        /// Retrieves a stored email message
        @DependencyEndpoint
        public var retrieve: @Sendable (_ storageKey: String) async throws -> Mailgun.Messages.StoredMessage
        
        /// Gets the message queue status for a domain
        @DependencyEndpoint
        public var queueStatus: @Sendable () async throws -> Mailgun.Messages.Queue.Status
        
        /// Deletes all scheduled and undelivered mail from the domain queue
        @DependencyEndpoint
        public var deleteAll: @Sendable () async throws -> Mailgun.Messages.Delete.Response
    }
}

extension Client.Messages: TestDependencyKey {
    public static var testValue: Self {
                
        return Self(
            send: { _ in
                .init(id: "test-id", message: "Queued. Thank you.")
            },
            sendMime: { _ in
                .init(id: "test-id", message: "Queued. Thank you.")
            },
            retrieve: { _ in
                .init(
                    contentTransferEncoding: "7bit",
                    contentType: "text/html; charset=ascii",
                    from: "test@example.com",
                    messageId: "<test-id@example.com>",
                    mimeVersion: "1.0",
                    subject: "Test Subject",
                    to: "recipient@example.com",
                    tags: ["test"],
                    sender: "test@example.com",
                    recipients: "recipient@example.com",
                    bodyHtml: "<html>Test</html>",
                    bodyPlain: "Test",
                    strippedHtml: "<html>Test</html>",
                    strippedText: "Test",
                    strippedSignature: nil,
                    messageHeaders: [],
                    templateName: nil,
                    templateVariables: nil
                )
            },
            queueStatus: {
                .init(
                    regular: .init(isDisabled: false, disabled: nil),
                    scheduled: .init(isDisabled: false, disabled: nil)
                )
            },
            deleteAll: {
                .init(message: "done")
            }
        )
    }
}
