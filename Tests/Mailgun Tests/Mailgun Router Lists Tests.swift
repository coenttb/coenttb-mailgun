//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Foundation
import URLRouting
import Mailgun

@Suite("Mailgun Router Lists URL Tests")
struct MailgunRouterTests {
    
    @Test("Creates correct URL for list creation")
    func testCreateListURL() throws {
        @Dependency(\.mailgunRouter) var router
        
        let createRequest = Mailgun.Lists.List.Create.Request(
            address: "developers@test.com",
            name: "Developers",
            description: "Test list",
            accessLevel: .readonly,
            replyPreference: .list
        )
        
        let url = router.url(for: .lists(.create(request: createRequest)))
        #expect(url.path == "/v3/lists")
    }
    
    @Test("Creates correct URL for listing all mailing lists")
    func testListMailingListsURL() throws {
        @Dependency(\.mailgunRouter) var router
        
        let listRequest = Mailgun.Lists.List.Request(
            limit: 100,
            skip: 0,
            address: "test@example.com"
        )
        
        let url = router.url(for: .lists(.list(request: listRequest)))
        #expect(url.path == "/v3/lists")
        
        // Parse the query string into a dictionary
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        #expect(queryDict["limit"] == "100")
        #expect(queryDict["skip"] == "0")
        #expect(queryDict["address"] == "test@example.com")
    }
    
    @Test("Creates correct URL for getting list members")
    func testGetMembersURL() throws {
        @Dependency(\.mailgunRouter) var router
        
        let membersRequest = Mailgun.Lists.List.Members.Request(
            address: "test@example.com",
            subscribed: true,
            limit: 50,
            skip: 10
        )
        
        let url = router.url(for: .lists(.members(
            listAddress: "developers@test.com",
            request: membersRequest
        )))
        
        #expect(url.path == "/v3/lists/developers@test.com/members")
        #expect(url.query?.contains("subscribed=true") == true)
        #expect(url.query?.contains("limit=50") == true)
        #expect(url.query?.contains("skip=10") == true)
    }
    
    @Test("Creates correct URL for adding a member")
    func testAddMemberURL() throws {
        @Dependency(\.mailgunRouter) var router
        
        let addRequest = Mailgun.Lists.Member.Add.Request(
            address: "new@example.com",
            name: "New Member",
            vars: ["role": "developer"],
            subscribed: true,
            upsert: true
        )
        
        let url = router.url(for: .lists(.addMember(
            listAddress: "developers@test.com",
            request: addRequest
        )))
        
        #expect(url.path == "/v3/lists/developers@test.com/members")
    }
    
    @Test("Creates correct URL for bulk member addition")
    func testBulkAddURL() throws {
        @Dependency(\.mailgunRouter) var router
        
        let members = [
            Mailgun.Lists.Member.Bulk(
                address: "member1@example.com",
                name: "Member 1",
                vars: ["role": "admin"],
                subscribed: true
            )
        ]
        
        let url = router.url(for: .lists(.bulkAdd(
            listAddress: "developers@test.com",
            members: members,
            upsert: true
        )))
        
        #expect(url.path == "/v3/lists/developers@test.com/members.json")
        #expect(url.query?.contains("upsert=true") == true)
    }
    
    @Test("Creates correct URL for getting member details")
    func testGetMemberURL() throws {
        @Dependency(\.mailgunRouter) var router
        
        let url = router.url(for: .lists(.getMember(
            listAddress: "developers@test.com",
            memberAddress: "member@example.com"
        )))
        
        #expect(url.path == "/v3/lists/developers@test.com/members/member@example.com")
    }
    
    @Test("Creates correct URL for updating member")
    func testUpdateMemberURL() throws {
        @Dependency(\.mailgunRouter) var router
        
        let updateRequest = Mailgun.Lists.Member.Update.Request(
            address: "updated@example.com",
            name: "Updated Name",
            vars: ["role": "lead"],
            subscribed: false
        )
        
        let url = router.url(for: .lists(.updateMember(
            listAddress: "developers@test.com",
            memberAddress: "member@example.com",
            request: updateRequest
        )))
        
        #expect(url.path == "/v3/lists/developers@test.com/members/member@example.com")
    }
    
    @Test("Creates correct URL for deleting member")
    func testDeleteMemberURL() throws {
        @Dependency(\.mailgunRouter) var router
        
        let url = router.url(for: .lists(.deleteMember(
            listAddress: "developers@test.com",
            memberAddress: "member@example.com"
        )))
        
        #expect(url.path == "/v3/lists/developers@test.com/members/member@example.com")
    }
    
    @Test("Creates correct URL for updating list")
    func testUpdateListURL() throws {
        @Dependency(\.mailgunRouter) var router
        
        let updateRequest = Mailgun.Lists.List.Update.Request(
            address: "newaddress@test.com",
            name: "New Name",
            description: "Updated description",
            accessLevel: .members,
            replyPreference: .sender
        )
        
        let url = router.url(for: .lists(.update(
            listAddress: "developers@test.com",
            request: updateRequest
        )))
        
        #expect(url.path == "/v3/lists/developers@test.com")
    }
    
    @Test("Creates correct URL for deleting list")
    func testDeleteListURL() throws {
        @Dependency(\.mailgunRouter) var router
        
        let url = router.url(for: .lists(.delete(listAddress: "developers@test.com")))
        #expect(url.path == "/v3/lists/developers@test.com")
    }
    
    @Test("Creates correct URL for getting list details")
    func testGetListURL() throws {
        @Dependency(\.mailgunRouter) var router
        
        let url = router.url(for: .lists(.get(listAddress: "developers@test.com")))
        #expect(url.path == "/v3/lists/developers@test.com")
    }
    
    @Test("Creates correct URL for paginated lists")
    func testPagesURL() throws {
        @Dependency(\.mailgunRouter) var router
        
        let url = router.url(for: .lists(.pages(limit: 50)))
        #expect(url.path == "/v3/lists/pages")
        #expect(url.query?.contains("limit=50") == true)
    }
    
    @Test("Creates correct URL for paginated members")
    func testMemberPagesURL() throws {
        @Dependency(\.mailgunRouter) var router
        
        let request = Mailgun.Lists.List.Members.Pages.Request(
            subscribed: true,
            limit: 30,
            address: "test@example.com",
            page: .next
        )
        
        let url = router.url(for: .lists(.memberPages(
            listAddress: "developers@test.com",
            request: request
        )))
        
        print("url.query!", url.query!)
        
        #expect(url.path == "/v3/lists/developers@test.com/members/pages")
        #expect(url.query?.contains("subscribed=true") == true)
        #expect(url.query?.contains("limit=30") == true)
//        #expect(url.query?.contains("address=test%40example.com") == true)
        #expect(url.query?.contains("address=test@example.com") == true)
        #expect(url.query?.contains("page=next") == true)
    }
}
