//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Coenttb_Web
import IssueReporting
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Templates.Client {
    public static func live(
        apiKey: ApiKey,
        domain: Domain,
        makeRequest: @escaping @Sendable (_ route: Templates.API) throws -> URLRequest
    ) -> Self {
        @Dependency(URLRequest.Handler.self) var handleRequest
        
        return Self(
            create: { request in
                try await handleRequest(
                    for: makeRequest(.create(request: request)),
                    decodingTo: Templates.Template.Create.Response.self
                )
            },
            
            list: { request in
                try await handleRequest(
                    for: makeRequest(.list(domainId: domain, page: request.page, limit: request.limit, p: request.p)),
                    decodingTo: Templates.Template.List.Response.self
                )
            },
            
            get: { templateId, active in
                try await handleRequest(
                    for: makeRequest(.get(domainId: domain,  templateId: templateId, active: active)),
                    decodingTo: Templates.Template.Get.Response.self
                )
            },
            
            update: { templateId, request in
                try await handleRequest(
                    for: makeRequest(.update(domainId: domain, templateId: templateId, request: request)),
                    decodingTo: Templates.Template.Update.Response.self
                )
            },
            
            delete: { templateId in
                try await handleRequest(
                    for: makeRequest(.delete(domainId: domain, templateId: templateId)),
                    decodingTo: Templates.Template.Delete.Response.self
                )
            },
            
            versions: { templateId, request in
                try await handleRequest(
                    for: makeRequest(.versions(domainId: domain, templateId: templateId, page: request.page, limit: request.limit)),
                    decodingTo: Templates.Template.Versions.Response.self
                )
            },
            
            createVersion: { templateId, request in
                try await handleRequest(
                    for: makeRequest(.createVersion(domainId: domain, templateId: templateId, request: request)),
                    decodingTo: Templates.Version.Create.Response.self
                )
            },
            
            getVersion: { templateId, versionId in
                try await handleRequest(
                    for: makeRequest(.getVersion(domainId: domain, templateId: templateId, versionId: versionId)),
                    decodingTo: Templates.Version.Get.Response.self
                )
            },
            
            updateVersion: { templateId, versionId, request in
                try await handleRequest(
                    for: makeRequest(.updateVersion(domainId: domain, templateId: templateId, versionId: versionId, request: request)),
                    decodingTo: Templates.Version.Update.Response.self
                )
            },
            
            deleteVersion: { templateId, versionId in
                try await handleRequest(
                    for: makeRequest(.deleteVersion(domainId: domain, templateId: templateId, versionId: versionId)),
                    decodingTo: Templates.Version.Delete.Response.self
                )
            },
            
            copyVersion: { templateId, versionId, tag, comment in
                try await handleRequest(
                    for: makeRequest(.copyVersion(domainId: domain, templateId: templateId, versionId: versionId, tag: tag, comment: comment)),
                    decodingTo: Templates.Version.Copy.Response.self
                )
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
