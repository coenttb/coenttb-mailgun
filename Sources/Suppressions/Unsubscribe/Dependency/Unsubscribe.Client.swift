//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation
import CoenttbWeb
import Shared
import DependenciesMacros

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Unsubscribe {
    @DependencyClient
    public struct Client: Sendable {
        
        /// Fetch a single unsubscribe record
        @DependencyEndpoint
        public var get: @Sendable (_ address: EmailAddress) async throws -> Unsubscribe.Record
        
        /// Delete a specific unsubscribe record
        @DependencyEndpoint
        public var delete: @Sendable (_ address: EmailAddress) async throws -> Unsubscribe.Delete.Response
        
        /// Paginate over a list of unsubscribes for a domain
        @DependencyEndpoint
        public var list: @Sendable (_ request: Unsubscribe.List.Request) async throws -> Unsubscribe.List.Response
        
        /// Create a new unsubscribe record
        @DependencyEndpoint
        public var create: @Sendable (_ request: Unsubscribe.Create.Request) async throws -> Unsubscribe.Create.Response
        
        /// Delete all unsubscribe records for the domain
        @DependencyEndpoint
        public var deleteAll: @Sendable () async throws -> Unsubscribe.Delete.All.Response
        
        /// Import a CSV file containing a list of addresses to add to the unsubscribe list
        @DependencyEndpoint
        public var importList: @Sendable (_ request: Data) async throws -> Unsubscribe.Import.Response
    }
}



extension Unsubscribe.Client: TestDependencyKey {
    public static var testValue: Self {
        return Self(
            get: { _ in
                .init(
                    address: try .init("test@example.com"),
                    tags: ["*"],
                    createdAt: "Fri, 18 Oct 2024 18:28:14 UTC"
                )
            },
            delete: { _ in
                .init(
                    message: "Unsubscribe event has been removed",
                    address: try .init("test@example.com")
                )
            },
            list: { _ in
                .init(
                    items: [
                        .init(
                            address: try .init("test@example.com"),
                            tags: ["*"],
                            createdAt: "Fri, 18 Oct 2024 18:28:14 UTC"
                        )
                    ],
                    paging: .init(
                        previous: "https://api.mailgun.net/v3/domain/unsubscribes?page=prev",
                        first: "https://api.mailgun.net/v3/domain/unsubscribes?page=first",
                        next: "https://api.mailgun.net/v3/domain/unsubscribes?page=next",
                        last: "https://api.mailgun.net/v3/domain/unsubscribes?page=last"
                    )
                )
            },
            create: { _ in
                .init(message: "Unsubscribe event has been created")
            },
            deleteAll: {
                .init(
                    message: "All unsubscribe events have been removed"
                )
            },
            importList: { _ in
                .init(message: "file uploaded successfully")
            }
        )
    }
}