//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Dependencies
import DependenciesMacros
import Foundation
import UrlFormCoding

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Client {
    @DependencyClient
    public struct Lists: Sendable {
        /// Creates a new mailing list
        @DependencyEndpoint
        public var create: @Sendable (_ request: Mailgun.Lists.List.Create.Request) async throws -> Mailgun.Lists.List.Create.Response
        
        /// Gets all mailing lists with optional filtering
        @DependencyEndpoint
        public var list: @Sendable (_ request: Mailgun.Lists.List.Request) async throws -> Mailgun.Lists.List.Response
        
        /// Gets members of a specific mailing list
        @DependencyEndpoint
        public var members: @Sendable (_ listAddress: String, _ request: Mailgun.Lists.List.Members.Request) async throws -> Mailgun.Lists.List.Members.Response
        
        /// Adds a new member to a mailing list
        @DependencyEndpoint
        public var addMember: @Sendable (_ listAddress: String, _ request: Mailgun.Lists.Member.Add.Request) async throws -> Mailgun.Lists.Member.Add.Response
        
        /// Bulk adds members to a mailing list using JSON
        @DependencyEndpoint
        public var bulkAdd: @Sendable (_ listAddress: String, _ members: [Mailgun.Lists.Member.Bulk], _ upsert: Bool?) async throws -> Mailgun.Lists.Member.Bulk.Response
        
        /// Bulk adds members to a mailing list using CSV
        @DependencyEndpoint
        public var bulkAddCSV: @Sendable (_ listAddress: String, _ csvData: Data, _ subscribed: Bool?, _ upsert: Bool?) async throws -> Mailgun.Lists.Member.Bulk.Response
        
        /// Gets a specific member from a mailing list
        @DependencyEndpoint
        public var getMember: @Sendable (_ listAddress: String, _ memberAddress: String) async throws -> Mailgun.Lists.Member
        
        /// Updates a specific member in a mailing list
        @DependencyEndpoint
        public var updateMember: @Sendable (_ listAddress: String, _ memberAddress: String, _ request: Mailgun.Lists.Member.Update.Request) async throws -> Mailgun.Lists.Member.Update.Response
        
        /// Deletes a member from a mailing list
        @DependencyEndpoint
        public var deleteMember: @Sendable (_ listAddress: String, _ memberAddress: String) async throws -> Mailgun.Lists.Member.Delete.Response
        
        /// Updates a mailing list's properties
        @DependencyEndpoint
        public var update: @Sendable (_ listAddress: String, _ request: Mailgun.Lists.List.Update.Request) async throws -> Mailgun.Lists.List.Update.Response
        
        /// Deletes a mailing list
        @DependencyEndpoint
        public var delete: @Sendable (_ listAddress: String) async throws -> Mailgun.Lists.List.Delete.Response
        
        /// Gets details of a specific mailing list
        @DependencyEndpoint
        public var get: @Sendable (_ listAddress: String) async throws -> Mailgun.Lists.List.Get.Response
        
        /// Gets mailing lists with pagination
        @DependencyEndpoint
        public var pages: @Sendable (_ limit: Int?) async throws -> Mailgun.Lists.List.Pages.Response
        
        /// Gets members of a mailing list with pagination
        @DependencyEndpoint
        public var memberPages: @Sendable (_ listAddress: String, _ request: Mailgun.Lists.List.Members.Pages.Request) async throws -> Mailgun.Lists.List.Members.Pages.Response
    }
}
