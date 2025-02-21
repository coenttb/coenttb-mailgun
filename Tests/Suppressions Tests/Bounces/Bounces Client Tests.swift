//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import IssueReporting
import Shared
@testable import Suppressions

@Suite(
    "Bounces Client Tests",
    .dependency(\.envVars, .liveTest)
)
struct BouncesClientTests {
    @Test("Should successfully import bounce list")
    func testImportBounceList() async throws {
        @Dependency(\.suppressions.bounces) var client
        let testData = Data("test@example.com".utf8)
        
        let response = try await client.importList(testData)
        
        #expect(response.message == "file uploaded successfully")
    }
    
    @Test("Should successfully get bounce record")
    func testGetBounceRecord() async throws {
        @Dependency(\.suppressions.bounces) var client
        
        let bounce = try await client.get(.init("test@example.com"))
        
        #expect(bounce.address.address == "test@example.com")
        #expect(!bounce.code.isEmpty)
        #expect(!bounce.error.isEmpty)
        #expect(!bounce.createdAt.isEmpty)
    }
    
    @Test("Should successfully delete bounce record")
    func testDeleteBounceRecord() async throws {
        @Dependency(\.suppressions.bounces) var client
        
        let response = try await client.delete(.init("test@example.com"))
        
        #expect(response.message == "Bounce has been removed")
        #expect(response.address.address == "test@example.com")
    }
    
    @Test("Should successfully list bounce records")
    func testListBounceRecords() async throws {
        @Dependency(\.suppressions.bounces) var client
        
        let request = Bounces.List.Request(
            limit: 25,
            page: nil,
            term: nil
        )
        
        let response = try await client.list(request)
        
        #expect(!response.items.isEmpty)
        #expect(!response.paging.first.isEmpty)
        #expect(!response.paging.last.isEmpty)
    }
    
    @Test("Should successfully create bounce record")
    func testCreateBounceRecord() async throws {
        @Dependency(\.suppressions.bounces) var client
        
        let request = Bounces.Create.Request(
            address: try .init("test@example.com"),
            code: "550",
            error: "Test error"
        )
        
        let response = try await client.create(request)
        
        #expect(response.message == "Bounce event has been created")
    }
    
    @Test("Should successfully delete all bounce records")
    func testDeleteAllBounceRecords() async throws {
        @Dependency(\.suppressions.bounces) var client
        
        let response = try await client.deleteAll()
        
        #expect(response.message == "Bounced addresses for this domain have been removed")
    }
}
