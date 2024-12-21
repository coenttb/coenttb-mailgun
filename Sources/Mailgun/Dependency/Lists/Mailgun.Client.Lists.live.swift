//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Dependencies
import Foundation
import UrlFormCoding
import IssueReporting

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Client.Lists {
    public static func live(
        apiKey: Mailgun.Client.ApiKey,
        baseUrl: URL,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse),
        makeRequest: @escaping @Sendable (_ route: Mailgun.API.Lists) throws -> URLRequest
    ) -> Self {
        
        @Sendable func decodeResponse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
            do {
                return try JSONDecoder().decode(type, from: data)
            } catch {
                reportIssue(error)
                throw error
            }
        }

        return Self(
            create: { request in
                let (data, _) = try await session(makeRequest(.create(request: request)))
                return try decodeResponse(Mailgun.Lists.List.Create.Response.self, from: data)
            },
            
            list: { request in
                let (data, _) = try await session(makeRequest(.list(request: request)))
                return try decodeResponse(Mailgun.Lists.List.Response.self, from: data)
            },
            
            members: { listAddress, request in
                let (data, _) = try await session(makeRequest(.members(listAddress: listAddress, request: request)))
                return try decodeResponse(Mailgun.Lists.List.Members.Response.self, from: data)
            },
            
            addMember: { listAddress, request in
                let (data, _) = try await session(makeRequest(.addMember(listAddress: listAddress, request: request)))
                return try decodeResponse(Mailgun.Lists.Member.Add.Response.self, from: data)
            },
            
            bulkAdd: { listAddress, members, upsert in
                let (data, _) = try await session(makeRequest(.bulkAdd(listAddress: listAddress, members: members, upsert: upsert)))
                return try decodeResponse(Mailgun.Lists.Member.Bulk.Response.self, from: data)
            },
            
            bulkAddCSV: { listAddress, csvData, subscribed, upsert in
                let (data, _) = try await session(makeRequest(.bulkAddCSV(listAddress: listAddress, request: csvData, subscribed: subscribed, upsert: upsert)))
                return try decodeResponse(Mailgun.Lists.Member.Bulk.Response.self, from: data)
            },
            
            getMember: { listAddress, memberAddress in
                let (data, _) = try await session(makeRequest(.getMember(listAddress: listAddress, memberAddress: memberAddress)))
                return try decodeResponse(Mailgun.Lists.Member.self, from: data)
            },
            
            updateMember: { listAddress, memberAddress, request in
                let (data, _) = try await session(makeRequest(.updateMember(listAddress: listAddress, memberAddress: memberAddress, request: request)))
                return try decodeResponse(Mailgun.Lists.Member.Update.Response.self, from: data)
            },
            
            deleteMember: { listAddress, memberAddress in
                let (data, _) = try await session(makeRequest(.deleteMember(listAddress: listAddress, memberAddress: memberAddress)))
                return try decodeResponse(Mailgun.Lists.Member.Delete.Response.self, from: data)
            },
            
            update: { listAddress, request in
                let (data, _) = try await session(makeRequest(.update(listAddress: listAddress, request: request)))
                return try decodeResponse(Mailgun.Lists.List.Update.Response.self, from: data)
            },
            
            delete: { listAddress in
                let (data, _) = try await session(makeRequest(.delete(listAddress: listAddress)))
                return try decodeResponse(Mailgun.Lists.List.Delete.Response.self, from: data)
            },
            
            get: { listAddress in
                let (data, _) = try await session(makeRequest(.get(listAddress: listAddress)))
                return try decodeResponse(Mailgun.Lists.List.Get.Response.self, from: data)
            },
            
            pages: { limit in
                let (data, _) = try await session(makeRequest(.pages(limit: limit)))
                return try decodeResponse(Mailgun.Lists.List.Pages.Response.self, from: data)
            },
            
            memberPages: { listAddress, request in
                let (data, _) = try await session(makeRequest(.memberPages(listAddress: listAddress, request: request)))
                return try decodeResponse(Mailgun.Lists.List.Members.Pages.Response.self, from: data)
            }
        )
    }
}

private let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    return decoder
}()


private let jsonEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    return encoder
}()

